
require 'Coat'
require 'Coat.Types'

local assert = assert
local ipairs = ipairs
local table = require 'table'


abstract 'Smc.Element'

has.filename        = { is = 'ro', isa = 'string', required = true }
has.lineno          = { is = 'ro', isa = 'number', required = true }
has.name            = { is = 'ro', isa = 'string', required = true }


class 'Smc.FSM'
extends 'Smc.Element'

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
has.isValid         = { is = 'rw', isa = 'boolean', default = true }

function method:addMap (map)
    table.insert(self.maps, map)
end

function method:findMap (name)
    for _, map in ipairs(self.maps) do
        if map.name == name then
            return map
        end
    end
end


class 'Smc.Map'
extends 'Smc.Element'

has.fsm             = { is = 'ro', isa = 'Smc.FSM', required = true }
has.states          = { is = 'rw', isa = 'table<Smc.State>',
                        default = function () return {} end }
has.defaultState    = { is = 'rw', isa = 'Smc.State' }


function method:addState (state)
    if state.name == 'DefaultState' then
        self.defaultState = state
    else
        table.insert(self.states, state)
    end
end

function method:isKnownState (name)
    if name == 'DefaultState' then
        return self.defaultState
    else
        for _, state in ipairs(self.states) do
            if state.name == name then
                return true
            end
        end
        return false
    end
end


class 'Smc.State'
extends 'Smc.Element'

has.map             = { is = 'ro', isa = 'Smc.Map', required = true }
has.entryActions    = { is = 'rw', isa = 'table<Smc.Action>' }
has.exitActions     = { is = 'rw', isa = 'table<Smc.Action>' }
has.transitions     = { is = 'rw', isa = 'table<Smc.Transition>',
                        default = function () return {} end }

function method:addTransition (transition)
    for _, trans in ipairs(self.transitions) do
        if trans == transition then
            return
        end
    end
    table.insert(self.transitions, transition)
end

function method:findTransition (name)
    for _, trans in ipairs(self.transitions) do
        if trans.name == name then
            return trans
        end
    end
    return nil
end


class 'Smc.Transition'
extends 'Smc.Element'

has.state           = { is = 'ro', isa = 'Smc.State', required = true }
has.parameters      = { is = 'ro', isa = 'table<Smc.Parameter>', required = true }
has.guards          = { is = 'rw', isa = 'table<Smc.Guard>',
                        default = function () return {} end }

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

has.transition      = { is = 'ro', isa = 'Smc.Transition', required = true }
has.condition       = { is = 'ro', isa = 'string', required = true }
has.transType       = { is = 'rw', isa = 'Smc.TransType' }
has.endState        = { is = 'rw', isa = 'string', }
has.pushState       = { is = 'rw', isa = 'string', }
has.popArgs         = { is = 'rw', isa = 'string', }
has.actions         = { is = 'rw', isa = 'table<Smc.Action>' }


class 'Smc.Action'
extends 'Smc.Element'

has.propertyFlag    = { is = 'rw', isa = 'boolean', default = false }
has.arguments       = { is = 'rw', isa = 'table<string>',
                        trigger = function (self, value)
                            if self.propertyFlag then
                                assert(#value == 1, "property must have exactly one argument")
                            end
                        end }

function method:BUILD ()
    if self.propertyFlag then
        assert(#self.arguments == 1, "property must have exactly one argument")
    end
end


class 'Smc.Parameter'
extends 'Smc.Element'

has._type           = { is = 'rw', isa = 'string' }

