
require 'Coat'
require 'Coat.Types'

local table = require 'table'
local error = error
local pairs = pairs
local unpack = table.unpack or unpack

abstract 'Smc.Element'

has.filename        = { is = 'ro', isa = 'string', required = true }
has.lineno          = { is = 'ro', isa = 'number', required = true }
has.name            = { is = 'ro', isa = 'string' }

function method:visit (visitor, ...)
    local t = self:type()
    visitor['visit' .. t:sub(5)](visitor, self, ...)
end


class 'Smc.FSM'
extends 'Smc.Element'

has.name            = { '+', required = true }
has.targetFilename  = { is = 'rw', isa = 'string', required = true }
has.source          = { is = 'rw', isa = 'string' }
has.startState      = { is = 'rw', isa = 'string' }
has.context         = { is = 'rw', isa = 'string' }
has.fsmClassname    = { is = 'rw', isa = 'string', lazy = true,
                        default = function (self) return self.name .. 'Context' end,
                        trigger = function (self, value) self.targetFilename = value end }
has._package        = { is = 'rw', isa = 'string' }
has.accessLevel     = { is = 'rw', isa = 'string' }
has.header          = { is = 'rw', isa = 'string' }
has.includeList     = { is = 'rw', isa = 'table<string>',
                        default = function () return {} end }
has.importList      = { is = 'rw', isa = 'table<string>',
                        default = function () return {} end }
has.declareList     = { is = 'rw', isa = 'table<string>',
                        default = function () return {} end }
has.maps            = { is = 'rw', isa = 'table<Smc.Map>',
                        default = function () return {} end }
has.transitions     = { is = 'ro', lazy_build = true }
has.hasEntryActions = { is = 'ro', lazy_build = true }
has.hasExitActions  = { is = 'ro', lazy_build = true }
has.isValid         = { is = 'rw', isa = 'boolean', default = true }

function method:_build_transitions ()
    hash = {}
    for i = 1, #self.maps do
        local map = self.maps[i]
        for j = 1, #map.transitions do
            local trans = map.transitions[j]
            hash[trans.name] = trans
        end
    end
    all = {}
    for _, v in pairs(hash) do
        table.insert(all, v)
    end
    return all
end

function method:_build_hasEntryActions ()
    for i = 1, #self.maps do
        if self.maps[i].hasEntryActions then
            return true
        end
    end
    return false
end

function method:_build_hasExitActions ()
    for i = 1, #self.maps do
        if self.maps[i].hasExitActions then
            return true
        end
    end
    return false
end

function method:addMap (map)
    table.insert(self.maps, map)
end

function method:findMap (name)
    for i = 1, #self.maps do
        local map = self.maps[i]
        if map.name == name then
            return map
        end
    end
end


class 'Smc.Map'
extends 'Smc.Element'

has.name            = { '+', required = true }
has.fsm             = { is = 'ro', isa = 'Smc.FSM', required = true }
has.states          = { is = 'rw', isa = 'table<Smc.State>',
                        default = function () return {} end }
has.defaultState    = { is = 'rw', isa = 'Smc.State' }
has.allStates       = { is = 'ro', lazy_build = true }
has.transitions     = { is = 'ro', lazy_build = true }
has.hasEntryActions = { is = 'ro', lazy_build = true }
has.hasExitActions  = { is = 'ro', lazy_build = true }

function method:_build_allStates ()
    local default = self.defaultState
    if default then
        return { default, unpack(self.states) }
    else
        return self.states
    end
end

function method:_build_transitions ()
    hash = {}
    for i = 1, #self.allStates do
        local state = self.allStates[i]
        for j = 1, #state.transitions do
            local trans = state.transitions[j]
            hash[trans.name] = trans
        end
    end
    all = {}
    for _, v in pairs(hash) do
        table.insert(all, v)
    end
    return all
end

function method:_build_hasEntryActions ()
    for i = 1, #self.states do
        actions = self.states[i].entryActions
        if actions then
            return true
        end
    end
    return false
end

function method:_build_hasExitActions ()
    for i = 1, #self.states do
        actions = self.states[i].exitActions
        if actions then
            return true
        end
    end
    return false
end

local StateId = 0
function _get_nextStateId ()
    StateId = StateId + 1
    return StateId
end

function method:addState (state)
    if state.instanceName == 'DefaultState' then
        self.defaultState = state
    else
        table.insert(self.states, state)
    end
end

function method:isKnownState (name)
    if name:lower() == 'default' then
        return self.defaultState
    else
        for i = 1, #self.states do
            if self.states[i].instanceName == name then
                return true
            end
        end
        return false
    end
end


class 'Smc.State'
extends 'Smc.Element'

has.name            = { '+', lazy_build = true }
has.instanceName    = { is = 'rw', isa = 'string', required = true }
has.map             = { is = 'ro', isa = 'Smc.Map', required = true }
has.className       = { is = 'rw', isa = 'string' }
has.entryActions    = { is = 'rw', isa = 'table<Smc.Action>' }
has.exitActions     = { is = 'rw', isa = 'table<Smc.Action>' }
has.transitions     = { is = 'rw', isa = 'table<Smc.Transition>',
                        default = function () return {} end }

function method:_build_name ()
    return self.className .. '.' .. self.instanceName
end

function method:BUILD ()
    local name = self.instanceName
    if name:lower() == 'default' then
        self.instanceName = 'DefaultState'
    end
    self.className = name:sub(1,1):upper() .. name:sub(2)
end

function method:addTransition (transition)
    for i = 1, #self.transitions do
        if self.transitions[i] == transition then
            return
        end
    end
    table.insert(self.transitions, transition)
end

function method:findTransition (name)
    for i = 1, #self.transitions do
        local trans = self.transitions[i]
        if trans.name == name then
            return trans
        end
    end
    return nil
end

function method:findGuard (name, condition)
    condition:gsub('%s+', '')
    for i = 1, #self.transitions do
        local trans = self.transitions[i]
        if trans.name == name then
            for j = 1, #trans.guards do
                local trans = trans.guards[j]
                if guard.condition:gsub('%s+', '') == condition then
                    return guard
                end
            end
        end
    end
    return nil
end

function method:callDefault (transName)
    for i = 1, #self.transitions do
        local trans = self.transitions[i]
        if trans.name == transName then
            for j = 1, #trans.guards do
                if trans.guards[j].condition == '' then
                    return false
                end
            end
            return true
        end
    end
    for i = 1, #self.transitions do
        if trans.guards[i].name == 'Default' then
            return false
        end
    end
    return true
end

class 'Smc.Transition'
extends 'Smc.Element'

has.name            = { '+', required = true }
has.state           = { is = 'ro', isa = 'Smc.State', required = true }
has.parameters      = { is = 'ro', isa = 'table<Smc.Parameter>', required = true }
has.guards          = { is = 'rw', isa = 'table<Smc.Guard>',
                        default = function () return {} end }
has.hasCtxtReference= { is = 'ro', lazy_build = true }

function method:_build_hasCtxtReference ()
    for i = 1, #self.guards do
        if self.guards[i].hasCtxtReference then
            return true
        end
    end
    return false
end

function method:addGuard (guard)
    assert(guard.transType)
    assert(guard.endState)
    table.insert(self.guards, guard)
end


class 'Smc.Guard'
extends 'Smc.Element'

enum.Smc.TransType = {
    'TRANS_SET',
    'TRANS_PUSH',
    'TRANS_POP',
}

has.name            = { '+', required = true }
has.transition      = { is = 'ro', isa = 'Smc.Transition', required = true }
has.condition       = { is = 'ro', isa = 'string', required = true }
has.transType       = { is = 'rw', isa = 'Smc.TransType' }
has.endState        = { is = 'rw', isa = 'string', }
has.pushState       = { is = 'rw', isa = 'string', }
has.popArgs         = { is = 'rw', isa = 'string', }
has.actions         = { is = 'rw', isa = 'table<Smc.Action>' }
has.hasActions      = { is = 'ro', lazy_build = true }
has.hasCtxtReference= { is = 'ro', lazy_build = true }

function method:_build_hasActions ()
    if self.actions then
        for i = 1, #self.actions do
            if not self.actions[i].isEmptyStateStack then
                return true
            end
        end
    end
    return false
end

function method:_build_hasCtxtReference ()
    local condition = self.condition
    local popArgs = self.popArgs
    return (condition:match'ctxt '
         or condition:match'ctxt.'
         or condition:match'ctxt->'
         or condition:match'ctxt:')
        or self.hasActions
        or (self.transType == 'TRANS_POP'
            and (popArgs:match'ctxt '
              or popArgs:match'ctxt.'
              or popArgs:match'ctxt->'
              or popArgs:match'ctxt:'))
end


class 'Smc.Action'
extends 'Smc.Element'

has.name            = { '+', required = true }
has.staticFlag      = { is = 'ro', isa = 'boolean', default = false }
has.propertyFlag    = { is = 'rw', isa = 'boolean', default = false }
has.arguments       = { is = 'rw', isa = 'table<string>',
                        trigger = function (self, value)
                            if self.propertyFlag then
                                assert(#value == 1, "property must have exactly one argument")
                            end
                        end }
has.isEmptyStateStack= { is = 'ro', lazy_build = true }

function method:BUILD ()
    if self.propertyFlag then
        assert(#self.arguments == 1, "property must have exactly one argument")
    end
end

function method:_build_isEmptyStateStack ()
    return 'emptystatestack' == self.name:lower()
end


class 'Smc.Parameter'
extends 'Smc.Element'

has.name            = { '+', required = true }
has._type           = { is = 'rw', isa = 'string' }

