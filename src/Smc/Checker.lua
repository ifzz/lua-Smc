
require 'Coat'

local table = require 'table'
local ipairs = ipairs

require 'Smc.Generator'

class 'Smc.Checker'
with 'Smc.Visitor'

has.name            = { is = 'ro', isa = 'string', required = true }
has.targetLanguage  = { is = 'ro', isa = 'string', required = true }
has.isValid         = { is = 'rw', isa = 'boolean', default = true }
has.messages        = { is = 'rw', isa = 'table<Smc.Message>',
                        default = function () return {} end }

function method:warning (text, filename, lineno)
    local msg = Smc.Message.new{
        filename = filename,
        lineno = lineno or 0,
        level = 'WARNING',
        text = text,
    }
    table.insert(self.messages, msg)
end

function method:_error (text, filename, lineno)
    local msg = Smc.Message.new{
        filename = filename,
        lineno = lineno or 0,
        level = 'ERROR',
        text = text,
    }
    table.insert(self.messages, msg)
    self.isValid = false
end

function method:visitFSM (fsm)
    self.isValid = fsm.isValid

    if not fsm.startState then
        self:_error("\"%start\" missing.", fsm.filename)
    end

    if not fsm.context then
        self:_error("\"%class\" missing.", fsm.filename)
    end

    if self.targetLanguage == 'C_PLUS_PLUS' and not fsm.header then
        self:_error("\"%header\" missing.", fsm.filename)
    end

    if self.targetLanguage == 'JAVA' and not fsm.name ~= fsm.context then
        self:_error(".sm file name \"" .. fsm.name .. "\" does not match context class name \""
                                       .. fsm.context .. "\".", filename)
    end

    for _, map in ipairs(fsm.maps) do
        map:visit(self)
    end
end

function method:visitMap (map)
    for _, state in ipairs(map.states) do
        state:visit(self)
    end
    local defaultState = map.defaultState
    if defaultState then
        defaultState:visit(self)
    end
end

function method:visitState (state)
    for _, trans in ipairs(state.transitions) do
        trans:visit(self)
    end
end

function method:visitTransition (transition)
    if #transition.guards > 1 then
        local hash = {}
        for _, guard in ipairs(transition.guards) do
            local condition = guard.condition
            if hash[condition] then
                local state = transition.state
                local mapName = state.map.name
                local stateName = state.className
                local transName = transition.name
                self:_error("State " .. mapName .. "::" .. stateName
                         .. " has multiple transitions with same name (\""
                         .. transName .. "\") and guard (\"" .. condition .. "\").",
                            guard.filename, guard.lineno)
            else
                hash[condition] = true
            end
        end
    end

    for _, param in ipairs(transition.parameters) do
        param:visit(self)
    end

    for _, guard in ipairs(transition.guards) do
        guard:visit(self)
    end
end

function method:visitGuard (guard)
    function findState (endState)
        local idx = endState:find '::'
        local transition = guard.transition
        local state = transition.state
        local map = state.map
        if not idx then
            return map:isKnownState(endState)
        else
            local mapName = endState:sub(1, idx-1)
            local stateName = endState:sub(idx+2)
            if mapName == map.name then
                if stateName == state.name then
                    return true
                else
                    return map:isKnownState(stateName)
                end
            else
                map = map.fsm:findMap(mapName)
                if map then
                    return map:isKnownState(stateName)
                else
                    return false
                end
            end
        end
    end -- findState

    local transType = guard.transType
    local endState = guard.endState
    if transType == 'TRANS_POP' then
        -- nothing
    elseif endState:lower() == 'default' then
        self:_error("may not transition to the default state.", guard.filename, guard.lineno)
    elseif endState ~= 'nil' and not findState(endState) then
        self:_error("no such state as \"" .. endState .. "\".", guard.filename, guard.lineno)
    end

    if transType == 'TRANS_PUSH' then
        local endState = guard.pushState
        if not findState(endState) then
            self:_error("no such state as \"" .. endState .. "\".", guard.filename, guard.lineno)
        end
    end
end

function method:visitAction (action)
end

function method:visitParameter (parameter)
    if self.targetLanguage == 'TCL' then
        local _type = parameter._type or 'value'
        if _type ~= 'value' and _type ~= 'reference' then
            self:_error("Tcl parameter type not \"value\" or \"reference\" but \""
                        .. _type .. "\".", parameter.filename, parameter.lineno)
        end
    end
end


class 'Smc.Dumper'
extends 'Smc.Generator'

function method:visitFSM (fsm)
    local stream = self.stream

    stream:write("Start State: ", fsm.startState or "", "\n")
    stream:write("    Context: ", fsm.context or "", "\n")
    stream:write("       Maps:\n")

    for _, map in ipairs(fsm.maps) do
        map:visit(self)
    end
end

function method:visitMap (map)
    local stream = self.stream

    stream:write("%map ", map.name, "\n")

    local defaultState = map.defaultState
    if defaultState then
        defaultState:visit(self)
    end

    for _, state in ipairs(map.states) do
        state:visit(self)
    end
end

function method:visitState (state)
    local stream = self.stream

    if state.entryActions then
        stream:write "\tEntry {\n"
        for _, action in ipairs(state.entryActions) do
            action:visit(self)
        end
        stream:write "\t}\n"
    end

    if state.exitActions then
        stream:write "\tExit {\n"
        for _, action in ipairs(state.exitActions) do
            action:visit(self)
        end
        stream:write "\t}\n"
    end

    for _, trans in ipairs(state.transitions) do
        trans:visit(self)
    end
end

function method:visitTransition (transition)
    local stream = self.stream

    local params = table.concat(transition.parameters, ", ")
    stream:write(transition.name, "(", params, ")\n")

    for _, guard in ipairs(transition.guards) do
        guard:visit(self)
    end
end

function method:visitGuard (guard)
    local stream = self.stream

    stream:write(guard.name)
    local condition = guard.condition
    if condition ~= '' then
        stream:write(" [", condition, "]")
    end

    local transType = guard.transType
    if transType == 'TRANS_SET' or transType == 'TRANS_PUSH' then
        stream:write " set"
    elseif transType == 'TRANS_POP' then
        stream:write " pop"
    end

    stream:write(" ", guard.endState)
    if transType == 'TRANS_PUSH' then
        stream:write("/", " push(", guard.pushState, ")")
    end

    stream:write " {\n"
    local actions = guard.actions or {}
    for _, action in ipairs(actions) do
        stream:write "    "
        action:visit(self)
        stream:write ";\n"
    end
    stream:write "}\n"
end

function method:visitAction (action)
    local stream = self.stream

    stream:write(action.name)
    if action.propertyFlag then
        stream:write(" = ", action.arguments[1])
    else
        local args = table.concat(action.arguments or {}, ", ")
        stream:write("(", args, ")")
    end
end

function method:visitParameter (parameter)
end