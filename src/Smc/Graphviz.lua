
require 'Coat'

local pairs = pairs

singleton 'Smc.Graphviz'
extends 'Smc.Language'

has.id              = { '+', default = 'GRAPH' }
has.name            = { '+', default = 'Graphviz' }
has.option          = { '+', default = '-graph' }
has.suffix          = { '+', default = '_sm' }
has.generator       = { '+', isa = 'Smc.Graphviz.Generator',
                        default = function () return require 'Smc.Graphviz.Generator' end }
has.glevelFlag      = { '+', default = true }


class 'Smc.Graphviz.Generator'
extends 'Smc.Generator'

has.suffix          = { '+', default = 'dot' }
has.state           = { is = 'rw', isa = 'Smc.State' }

local indent_action = "&nbsp;&nbsp;&nbsp;"

local function escape (s)
    s = s:gsub("\\", "\\\\")
    s = s:gsub("\"", "\\\"")
    return s
end

local function normalize (s)
    s = s:gsub("%s+", " ")
    return s
end

function method:visitFSM (fsm)
    local stream = self.stream

    stream:write "// ex: set ro:\n"
    stream:write "// DO NOT EDIT.\n"
--    stream:write "// generated by smc (http://smc.sourceforge.net/)\n"
    stream:write("// from file : ", fsm.filename, "\n")
    stream:write "\n"
    stream:write("digraph ", fsm.name, " {\n")
    stream:write "\n"
    stream:write "    node\n"
    stream:write "        [shape=Mrecord width=1.5];\n"
    stream:write "\n"

    for i = 1, #fsm.maps do
        local map = fsm.maps[i]
        local mapName = map.name
        stream:write("    subgraph cluster_", mapName, " {\n")
        stream:write "\n"
        stream:write("        label=\"", mapName, "\";\n")
        stream:write "\n"
        map:visit(self)
        stream:write "    }\n"
        stream:write "\n"
    end

    stream:write "}\n"
    stream:write "\n"
    stream:write "// Local variables:\n"
    stream:write "//  buffer-read-only: t\n"
    stream:write "// End:\n"
end

function method:visitMap (map)
    local stream = self.stream

    stream:write "        //\n"
    stream:write "        // States (Nodes)\n"
    stream:write "        //\n"
    stream:write "\n"

    for i = 1, #map.states do
        map.states[i]:visit(self)
    end

    local popTransMap = {}
    local function putPopTrans (guard)
        local endStateName = guard.endState
        local popKey = endStateName
        local popVal = endStateName
        local popArgs = guard.popArgs
        if self.graphLevel == 2 and popArgs ~= '' then
            popKey = popKey .. ", " .. escape(normalize(popArgs))
            popVal = popVal .. ", " .. escape(popArgs):gsub("\\n", "\\\\\\l")
        end
        popTransMap[popKey] = popVal
    end -- putPopTrans

    local mapName = map.name
    local pushStateMap = {}
    local function putPushState (guard, state)
        local endStateName = guard.endState
        if endStateName == 'nil' then
            endStateName = state.instanceName
        end
        local pushStateName = guard.pushState
        local pushMapName;
        local idx = pushStateName:find "::"
        if idx then
            pushMapName = pushStateName:sub(1, idx-1)
        else
            pushMapName = mapName
        end
        pushStateMap[mapName .. "::" .. endStateName .. "::" .. pushMapName] = pushMapName
    end -- putPushState

    local defaultState = map.defaultState
    local needEnd = false
    for i = 1, #map.states do
        local state = map.states[i]
        for j = 1, #state.transitions do
            local trans = state.transitions[j]
            for k = 1, #trans.guards do
                local guard = trans.guards[k]
                local transType = guard.transType
                if transType == 'TRANS_PUSH' then
                    putPushState(guard, state)
                elseif transType == 'TRANS_POP' then
                    putPopTrans(guard)
                    needEnd = true;
                end
            end
        end
        if defaultState then
            for j = 1, #defaultState.transitions do
                local trans = defaultState.transitions[j]
                local transName = trans.name
                if state:callDefault(transName) then
                    for k = 1, #trans.guards do
                        local guard = trans.guards[k]
                        if not state:findGuard(transName, guard.condition) then
                            local transType = guard.transType
                            if transType == 'TRANS_PUSH' then
                                putPushState(guard, state)
                            elseif transType == 'TRANS_POP' then
                                putPopTrans(guard)
                                needEnd = true;
                            end
                        end
                    end
                end
            end
        end
    end

    for k in pairs(popTransMap) do
        stream:write("        \"", mapName, "::pop(", k, ")\"\n")
        stream:write "            [label=\"\" width=1]\n"
        stream:write "\n"
    end

    if needEnd then
        stream:write("        \"", mapName, "::%end\"\n")
        stream:write "            [label=\"\" shape=doublecircle style=filled fillcolor=black width=0.15];\n"
        stream:write "\n"
    end

    for k, v in pairs(pushStateMap) do
        stream:write("        \"", k, "\"\n")
        stream:write("            [label=\"{", v, "|O-O\\r}\"]\n")
        stream:write "\n"
    end

    local startStateName = map.fsm.startState
    if startStateName:find(mapName) then
        stream:write "        \"%start\"\n"
        stream:write "            [label=\"\" shape=circle style=filled fillcolor=black width=0.25];\n"
        stream:write "\n"
    end

    local pushEntryMap = {}
    for i = 1, #map.fsm.maps do
        local map2 = map.fsm.maps[i]
        for j = 1, #map2.allStates do
            local state = map2.allStates[j]
            for k = 1, #state.transitions do
                local trans = state.transitions[k]
                for l = 1, #trans.guards do
                    local guard = trans.guards[l]
                    if guard.transType == 'TRANS_PUSH' then
                        local pushStateName = guard.pushState
                        if pushStateName:find(mapName) == 1 then
                            pushEntryMap[pushStateName] = true
                        end
                    end
                end
            end
        end
    end

    for k in pairs(pushEntryMap) do
        stream:write("        \"push(", k, ")\"\n")
        stream:write "            [label=\"\" shape=plaintext];\n"
        stream:write "\n"
    end

    stream:write "        //\n"
    stream:write "        // Transitions (Edges)\n"
    stream:write "        //\n"

    for i = 1, #map.states do
        local state = map.states[i]
        self.state = state
        for j = 1, #state.transitions do
            state.transitions[j]:visit(self)
        end
        if defaultState then
            for j = 1, #defaultState.transitions do
                local trans = defaultState.transitions[j]
                local transName = trans.name
                if state:callDefault(transName) then
                    for k = 1, #trans.guards do
                        local guard = trans.guards[k]
                        if not state:findGuard(transName, guard.condition) then
                            guard:visit(self)
                        end
                    end
                end
            end
        end
    end

    for k, v in pairs(popTransMap) do
        stream:write "\n"
        stream:write("        \"", mapName, "::pop(", k, ")\" -> \"", mapName, "::%end\"\n")
        stream:write("            [label=\"pop(", v, ");\\l\"];\n")
    end

    for k in pairs(pushStateMap) do
        local r = k:reverse()
        local s = r:sub(2 + r:find "::"):reverse()
        stream:write "\n"
        stream:write("        \"", k, "\" -> \"", s, "\"\n")
        stream:write "            [label=\"pop/\"]\n"
    end

    if startStateName:find(mapName) == 1 then
        stream:write "\n"
        stream:write("        \"%start\" -> \"", startStateName, "\"\n")
    end

    for k in pairs(pushEntryMap) do
        stream:write "\n"
        stream:write("        \"push(", k, ")\" -> \"", k, "\"\n")
        stream:write "            [arrowtail=odot];\n"
    end
end

function method:visitState (state)
    local stream = self.stream

    local map = state.map
    local mapName = map.name
    local instanceName = state.instanceName
    stream:write("        \"", mapName, "::", instanceName, "\"\n")
    stream:write("            [label=\"{", instanceName)

    if self.graphLevel >= 1 then
        local defaultState = map.defaultState
        local empty = true

        local actions = state.entryActions or (defaultState and defaultState.entryActions)
        if actions then
            if empty then
                stream:write "|"
                empty = false
            end
            stream:write "Entry/\\l"
            for i = 1, #actions do
                stream:write(indent_action)
                actions[i]:visit(self)
            end
        end

        local actions = state.exitActions or (defaultState and defaultState.exitActions)
        if actions then
            if empty then
                stream:write "|"
                empty = false
            end
            stream:write "Exit/\\l"
            for i = 1, #actions do
                stream:write(indent_action)
                actions[i]:visit(self)
            end
        end

        local function internalEvent (guard)
            local trans = guard.transition
            local transName = trans.name
            local endStateName = guard.endState
            local transType = guard.transType
            if endStateName == 'nil' and transType == 'TRANS_SET' then
                if empty then
                    stream:write "|"
                    empty = false
                end
                stream:write(transName)

                if self.graphLevel == 2 then
                    stream:write "("
                    local sep = ""
                    for i = 1, #trans.parameters do
                        stream:write(sep)
                        trans.parameters[i]:visit(self)
                        sep = ", "
                    end
                    stream:write ")"
                end

                local condition = guard.condition
                if condition ~= '' then
                    local s = escape(condition)
                    s = s:gsub("\\n", "\\\\\\l")
                    s = s:gsub(">", "\\\\>")
                    s = s:gsub("<", "\\\\<")
                    s = s:gsub("\\|", "\\\\|")
                    stream:write("\\l\\[", s, "\\]")
                end

                stream:write "/\\l"

                local actions = guard.actions
                if actions then
                    for i = 1, #actions do
                        stream:write(indent_action)
                        actions[i]:visit(self)
                    end
                end

                if transType == 'TRANS_PUSH' then -- XXX
                    stream:write(indent_action, "push(", guard.pushState, ")\\l")
                end
            end
        end -- internalEvent

        empty = true;
        for i = 1, #state.transitions do
            local trans = state.transitions[i]
            for j = 1, #trans.guards do
                internalEvent(trans.guards[j])
            end
        end
        if defaultState then
            for i = 1, #defaultState.transitions do
                local trans = defaultState.transitions[i]
                local transName = trans.name
                if state:callDefault(transName) then
                    for j = 1, #trans.guards do
                        local guard = trans.guards[j]
                        if not state:findGuard(transName, guard.condition) then
                            internalEvent(guard)
                        end
                    end
                end
            end
        end
    end

    stream:write "}\"];\n"
    stream:write "\n"
end

function method:visitTransition (transition)
    for i = 1, #transition.guards do
        transition.guards[i]:visit(self)
    end
end

function method:visitGuard (guard)
    local transType = guard.transType
    local endStateName = guard.endState
    if endStateName == 'nil' and transType == 'TRANS_SET' then
        return
    end

    local stream = self.stream

    local state = self.state
    local map = state.map
    local mapName = map.name
    local stateName = state.instanceName
    local pushStateName = guard.pushState
    stream:write "\n"
    stream:write("        \"", mapName, "::", stateName, "\" -> ")

    if transType ~= 'TRANS_POP' then
        if endStateName == 'nil' then
            endStateName = stateName;
        end

        if not endStateName:find "::" then
            endStateName = mapName .. "::" .. endStateName;
        end

        stream:write("\"", endStateName)

        if transType == 'TRANS_PUSH' then
            stream:write "::"
            local idx = pushStateName:find "::"
            if idx then
                stream:write(pushStateName:sub(1, idx-1))
            else
                stream:write(mapName)
            end
        end

        stream:write "\"\n"
    else
        stream:write("\"", mapName, "::pop(", endStateName)
        local popArgs = guard.popArgs
        if self.graphLevel == 2 and popArgs ~= '' then
            stream:write(", ", escape(normalize(popArgs)))
        end
        stream:write ")\"\n"
    end

    local transition = guard.transition
    local transName = transition.name
    stream:write("            [label=\"", transName)

    if self.graphLevel == 2 then
        stream:write "("
        local sep = ""
        for i = 1, #transition.parameters do
            stream:write(sep)
            transition.parameters[i]:visit(self)
            sep = ", "
        end
        stream:write ")"
    end

    local condition = guard.condition
    if self.graphLevel > 0 and condition ~= '' then
        local s = escape(condition)
        s = s:gsub("\\n", "\\\\\\l")
        stream:write("\\l\\[", s, "\\]")
    end
    stream:write "/\\l"

    local actions = guard.actions
    if self.graphLevel > 0 and actions then
        for i = 1, #actions do
            actions[i]:visit(self)
        end
    end

    if transType == 'TRANS_PUSH' then
        stream:write("push(", pushStateName, ")\\l")
    end

    stream:write "\"];\n"
end

function method:visitAction (action)
    local stream = self.stream

    if self.graphLevel >= 1 then
        stream:write(action.name)

        if self.graphLevel == 2 then
            if action.propertyFlag then
                local s = action.arguments[1]:gsub("\\\\", "\\\\\\\\")
                s = s:gsub("\"", "\\\"")
                stream:write(" = ", s)
            else
                stream:write "("

                local sep = ""
                for i = 1, #action.arguments do
                    local s = action.arguments[i]:gsub("\\\\", "\\\\\\\\")
                    s = s:gsub("\"", "\\\"")
                    stream:write(sep, s)
                    sep = ", "
                end

                stream:write ")"
            end
        end

        stream:write ";\\l"
    end
end

function method:visitParameter (parameter)
    local stream = self.stream
    stream:write(parameter.name)
    local _type = parameter._type or ''
    if _type ~= '' then
        stream:write(": ", _type)
    end
end

