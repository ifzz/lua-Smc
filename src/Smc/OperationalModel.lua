
require 'Coat'

local table = require 'table'
local ipairs = ipairs
local pairs = pairs
local unpack = table.unpack or unpack


augment 'Smc.FSM'

has.transitions     = { is = 'ro', lazy_build = true }
has.hasEntryActions = { is = 'ro', lazy_build = true }
has.hasExitActions  = { is = 'ro', lazy_build = true }

function method:_build_transitions ()
    local hash = {}
    for _, map in ipairs(self.maps) do
        for _, trans in ipairs(map.transitions) do
            hash[trans.name] = trans
        end
    end
    local all = {}
    for _, v in pairs(hash) do
        table.insert(all, v)
    end
    table.sort(all, function (a, b) return a.name < b.name end)
    return all
end

function method:_build_hasEntryActions ()
    for _, map in ipairs(self.maps) do
        if map.hasEntryActions then
            return true
        end
    end
    return false
end

function method:_build_hasExitActions ()
    for _, map in ipairs(self.maps) do
        if map.hasExitActions then
            return true
        end
    end
    return false
end


augment 'Smc.Map'

has.allStates       = { is = 'ro', lazy_build = true }
has.transitions     = { is = 'ro', lazy_build = true }
has.hasEntryActions = { is = 'ro', lazy_build = true }
has.hasExitActions  = { is = 'ro', lazy_build = true }
has.fullName        = { is = 'ro', lazy_build = true }
has.reflect         = { is = 'ro', lazy_build = true }

function method:_build_allStates ()
    local default = self.defaultState
    if default then
        return { default, unpack(self.states) }
    else
        return self.states
    end
end

function method:_build_fullName ()
    local packageName = self.fsm._package
    if packageName then
        return packageName .. '::' .. self.name
    else
        return self.name
    end
end

function method:_build_transitions ()
    local hash = {}
    for _, state in ipairs(self.allStates) do
        for _, trans in ipairs(state.transitions) do
            hash[trans.name] = trans
        end
    end
    local all = {}
    for _, v in pairs(hash) do
        table.insert(all, v)
    end
    table.sort(all, function (a, b) return a.name < b.name end)
    return all
end

function method:_build_hasEntryActions ()
    for _, state in ipairs(self.states) do
        actions = state.entryActions
        if actions then
            return true
        end
    end
    return false
end

function method:_build_hasExitActions ()
    for _, state in ipairs(self.states) do
        actions = state.exitActions
        if actions then
            return true
        end
    end
    return false
end

function method:_build_reflect ()
    local t = {}
    for _, trans in ipairs(self.fsm.transitions) do
        local transName = trans.name
        local def = 0
        local defaultState = self.defaultState
        if defaultState and defaultState:findTransition(transName) then
            def = 2
        end
        table.insert(t, { name = transName, def = def })
    end
    return t
end

local StateId = 0
function _get_nextStateId ()
    StateId = StateId + 1
    return StateId
end

function _get_index ()
    return _get_nextStateId() - 1
end


augment 'Smc.State'

has.fullName        = { is = 'ro', lazy_build = true }
has.reflect         = { is = 'ro', lazy_build = true }

function method:_build_fullName ()
    local packageName = self.map.fsm._package
    if packageName then
        return packageName .. '::' .. self.map.name .. '::' .. self.name
    else
        return self.map.name .. '::' .. self.name
    end
end

function method:_build_reflect ()
    local t = {}
    for _, trans in ipairs(self.map.fsm.transitions) do
        local transName = trans.name
        local def = 0
        if self:findTransition(transName) then
            def = 1
        else
            local defaultState = self.map.defaultState
            if defaultState and defaultState:findTransition(transName) then
                def = 2
            end
        end
        table.insert(t, { name = transName, def = def })
    end
    return t
end

function method:findGuard (name, condition)
    condition = condition:gsub('%s+', '')
    for _, trans in ipairs(self.transitions) do
        if trans.name == name then
            for _, guard in ipairs(trans.guards) do
                if guard.condition:gsub('%s+', '') == condition then
                    return guard
                end
            end
        end
    end
    return nil
end

function method:callDefault (transName)
    for _, trans in ipairs(self.transitions) do
        if trans.name == transName then
            for _, guard in ipairs(trans.guards) do
                if guard.condition == '' then
                    return false
                end
            end
            return true
        end
    end
    for _, trans in ipairs(self.transitions) do
        if trans.name == 'Default' then
            return false
        end
    end
    return true
end

augment 'Smc.Transition'

has.hasCtxtReference= { is = 'ro', lazy_build = true }
has.hasParameters   = { is = 'ro', lazy_build = true }
has.isntDefault     = { is = 'ro', lazy_build = true }
has.needFinalElse   = { is = 'ro', lazy_build = true }
has.needFinalEnd    = { is = 'ro', lazy_build = true }

function method:_build_hasCtxtReference ()
    for _, guard in ipairs(self.guards) do
        if guard.hasCtxtReference then
            return true
        end
    end
    return false
end

function method:_build_hasParameters ()
    return #self.parameters > 0
end

function method:_build_isntDefault ()
    return self.name ~= 'Default'
end

function method:_build_needFinalElse ()
    local nullCondition = false
    for _, guard in ipairs(self.guards) do
        if guard.condition == '' then
            nullCondition = true
        end
    end
    return #self.guards > 0 and not nullCondition
end

function method:_build_needFinalEnd ()
    return not self.needFinalElse and #self.guards > 1
end


augment 'Smc.Guard'

has.endStateName    = { is = 'ro', lazy_build = true }
has.hasActions      = { is = 'ro', lazy_build = true }
has.hasCondition    = { is = 'ro', lazy_build = true }
has.isConditional   = { is = 'ro', lazy_build = true }
has.hasCtxtReference= { is = 'ro', lazy_build = true }
has.ifCondition     = { is = 'ro', lazy_build = true }
has.elseifCondition = { is = 'ro', lazy_build = true }
has.isLoopback      = { is = 'ro', lazy_build = true }
has.doesEntry       = { is = 'ro', lazy_build = true }
has.doesExit        = { is = 'ro', lazy_build = true }
has.doesPush        = { is = 'ro', lazy_build = true }
has.doesPushSet     = { is = 'ro', lazy_build = true }
has.doesPushEntry   = { is = 'ro', lazy_build = true }
has.doesPop         = { is = 'ro', lazy_build = true }
has.doesEndPop      = { is = 'ro', lazy_build = true }
has.doesSet         = { is = 'ro', lazy_build = true }
has.pushStateName   = { is = 'ro', lazy_build = true }
has.needVarEndState = { is = 'ro', lazy_build = true }
has.pushMapName     = { is = 'ro', lazy_build = true }
has.isInternalEvent = { is = 'ro', lazy_build = true }

function method:_build_hasActions ()
    return self.actions and #self.actions > 0
end

function method:_build_hasCondition ()
    return self.condition ~= ''
end

function method:_build_isConditional ()
    return self.condition ~= '' or #self.transition.guards ~= 1
end

function method:_build_ifCondition ()
    return self == self.transition.guards[1] and self.condition ~= ''
end

function method:_build_elseifCondition ()
    return self.condition ~= ''
end

function method:_build_hasCtxtReference ()
    function hasRealActions ()
        if self.actions then
            for _, action in ipairs(self.actions) do
                if not action.isEmptyStateStack then
                    return true
                end
            end
        end
        return false
    end

    local condition = self.condition
    local popArgs = self.popArgs
    return condition:match'ctxt[^_%w]'
        or hasRealActions()
        or (self.transType == 'TRANS_POP'
            and popArgs:match'ctxt[^_%w]')
end

local function scopeStateName(stateName, mapName)
    if stateName:find '::' then
        return stateName
    else
        return mapName .. '::' .. stateName
    end
end

function method:_build_endStateName ()
    local endStateName = self.endState
    if self.transType == 'TRANS_POP' or endStateName == 'nil' then
        return endStateName
    end
    return scopeStateName(endStateName, self.transition.state.map.name)
end

function method:_build_isLoopback ()
    return (self.transType == 'TRANS_SET' or self.transType == 'TRANS_PUSH') and self.endState == 'nil'
end

function method:_build_doesEntry ()
    return (self.transType == 'TRANS_SET' and not self.isLoopback) or self.transType == 'TRANS_PUSH'
end

function method:_build_doesExit ()
    return self.transType == 'TRANS_POP' or not self.isLoopback
end

function method:_build_doesPush ()
    return self.transType == 'TRANS_PUSH'
end

function method:_build_doesPushSet ()
    return not self.isLoopback or #self.actions > 0
end

function method:_build_doesPushEntry ()
    return not self.isLoopback
end

function method:_build_doesPop ()
    return self.transType == 'TRANS_POP'
end

function method:_build_doesEndPop ()
    return self.transType == 'TRANS_POP' and self.endState ~= 'nil'
end

function method:_build_doesSet ()
    return self.transType == 'TRANS_SET' and (not self.isLoopback or #self.actions > 0)
end

function method:_build_pushStateName ()
    return scopeStateName(self.pushState, self.transition.state.map.name)
end

function method:_build_pushMapName ()
    local pushStateName = self.pushState
    local pushMapName;
    local idx = pushStateName:find "::"
    if idx then
        return pushStateName:sub(1, idx-1)
    else
        return self.transition.state.map.name
    end
end

function method:_build_needVarEndState ()
    return self.isLoopback and #self.actions > 0
end

function method:_build_isInternalEvent ()
    return self.endState == 'nil' and self.transType == 'TRANS_SET'
end


augment 'Smc.Action'

has.hasArguments    = { is = 'ro', lazy_build = true }
has.isEmptyStateStack= { is = 'ro', lazy_build = true }

function method:_build_hasArguments ()
    return #self.arguments > 0
end

function method:_build_isEmptyStateStack ()
    return 'emptystatestack' == self.name:lower()
end

