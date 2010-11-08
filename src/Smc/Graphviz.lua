
require 'Coat'
local CodeGen = require 'CodeGen'

local ipairs = ipairs
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

local function escape (s)
    s = s:gsub("\\", "\\\\")
    s = s:gsub("\"", "\\\"")
    s = s:gsub("\n", "\\l")
    s = s:gsub(">", "\\>")
    s = s:gsub("<", "\\<")
    s = s:gsub("\\|", "\\\\|")
    return s
end

local function normalize (s)
    s = s:gsub("%s+", " ")
    return s
end

function override:generate(fsm, stream)
    local function maps4dot ()
        local maps = {}
        for _, map in ipairs(fsm.maps) do
            local defaultState = map.defaultState
            local mapName = map.name

            local function states ()
                local t = {}
                for _, state in ipairs(map.states) do
                    local entryActions = state.entryActions or (defaultState and defaultState.entryActions)
                    local exitActions = state.exitActions or (defaultState and defaultState.exitActions)
                    local hasEntryExit = (entryActions ~= nil) or (exitActions ~= nil)
                    local internalEvents = {}
                    for _, trans in ipairs(state.transitions) do
                        for _, guard in ipairs(trans.guards) do
                            if guard.isInternalEvent then
                                table.insert(internalEvents, { guard = guard })
                            end
                        end
                    end
                    if defaultState then
                        for _, trans in ipairs(defaultState.transitions) do
                            local transName = trans.name
                            if state:callDefault(transName) then
                                for _, guard in ipairs(trans.guards) do
                                    if not state:findGuard(transName, guard.condition) then
                                        if guard.isInternalEvent then
                                            table.insert(internalEvents, { guard = guard })
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if #internalEvents == 0 then
                        internalEvents = nil
                    end
                    table.insert(t, {
                        state = state,
                        hasEntryExit = hasEntryExit,
                        entryActions = entryActions,
                        exitActions = exitActions,
                        internalEvents = internalEvents,
                    })
                end
                return t
            end  -- states

            local function guards ()
                local t = {}
                for _, state in ipairs(map.states) do
                    local function add_guard (guard)
                        local orig = mapName .. "::" .. state.name
                        local dest
                        local transType = guard.transType
                        if transType ~= 'TRANS_POP' then
                            local endStateName = guard.endState
                            if endStateName == 'nil' then
                                endStateName = state.name
                            end
                            if not endStateName:find "::" then
                                endStateName = mapName .. "::" .. endStateName
                            end
                            dest = endStateName
                            if transType == 'TRANS_PUSH' then
                                local pushStateName = guard.pushState
                                local idx = pushStateName:find "::"
                                if idx then
                                    dest = dest .. "::" .. pushStateName:sub(1, idx-1)
                                else
                                    dest = dest .. "::" .. mapName
                                end
                            end
                        else
                            local pop = guard.endState
                            local popArgs = guard.popArgs
                            if self.graphLevel == 2 and popArgs ~= '' then
                                pop = pop .. ", " .. escape(normalize(popArgs))
                            end
                            dest = mapName .. "::pop(" .. pop .. ")"
                        end
                        table.insert(t, { guard = guard, orig = orig, dest = dest })
                    end  -- add_guard

                    for _, trans in ipairs(state.transitions) do
                        for _, guard in ipairs(trans.guards) do
                            if not guard.isInternalEvent then
                                add_guard(guard)
                            end
                        end
                    end
                    if defaultState then
                        for _, trans in ipairs(defaultState.transitions) do
                            local transName = trans.name
                            if state:callDefault(transName) then
                                for _, guard in ipairs(trans.guards) do
                                    if not state:findGuard(transName, guard.condition) then
                                        if not guard.isInternalEvent then
                                            add_guard(guard)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                return t
            end  -- guards

            local function hasStart ()
                local startStateName = fsm.startState
                local startMapName = startStateName:sub(1, startStateName:find(':') - 1)
                return startMapName == mapName
            end  -- hasStart

            local function pushEntry ()
                local pushEntryMap = {}
                for _, map2 in ipairs(fsm.maps) do
                    for _, state in ipairs(map2.allStates) do
                        for _, trans in ipairs(state.transitions) do
                            for _, guard in ipairs(trans.guards) do
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
                local t = {}
                for k in pairs(pushEntryMap) do
                    local orig = "push(" .. k .. ")"
                    table.insert(t, { orig = orig, dest = k })
                end
                return t
            end  -- pushEntry

            local popTransMap = {}
            local function putPopTrans (guard)
                local endStateName = guard.endState
                local popKey = endStateName
                local popArgs = guard.popArgs
                if self.graphLevel == 2 and popArgs ~= '' then
                    popKey = popKey .. ", " .. escape(normalize(popArgs))
                end
                popTransMap[popKey] = true
            end -- putPopTrans
            local function popTrans ()
                local t = {}
                for k in pairs(popTransMap) do
                    table.insert(t, { pop = k })
                end
                return t
            end  -- popTrans

            local pushStateMap = {}
            local function putPushState (guard, state)
                local endStateName = guard.endState
                if endStateName == 'nil' then
                    endStateName = state.name
                end
                pushStateMap[mapName .. "::" .. endStateName .. "::" .. guard.pushMapName] = guard
            end -- putPushState
            local function pushState ()
                local t = {}
                for k, v in pairs(pushStateMap) do
                    local r = k:reverse()
                    local s = r:sub(2 + r:find "::"):reverse()
                    table.insert(t, { guard = v, orig = k, dest = s })
                end
                return t
            end  -- pushState

            local defaultState = map.defaultState
            local needEnd = false
            for _, state in ipairs(map.states) do
                for _, trans in ipairs(state.transitions) do
                    for _, guard in ipairs(trans.guards) do
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
                    for _, trans in ipairs(defaultState.transitions) do
                        local transName = trans.name
                        if state:callDefault(transName) then
                            for _, guard in ipairs(trans.guards) do
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

            table.insert(maps, {
                map = map,
                states = states(),
                guards = guards(),
                hasStart = hasStart(),
                pushEntry = pushEntry(),
                popTrans = popTrans(),
                pushState = pushState(),
                needEnd = needEnd,
            })
        end
        return maps
    end -- maps4dot

    local tmpl = self.template
    tmpl.fsm = fsm
    tmpl.generator = self
    tmpl.maps = maps4dot()
    local output, msg = tmpl 'TOP'
    stream:write(output)
    if msg then error(msg) end
end

function method:_build_template ()
    return CodeGen{
        TOP = [[
// ex: set ro:
// DO NOT EDIT.
// generated by smc (http://github.com/fperrad/lua-Smc)
// from file : ${fsm.filename}

digraph ${fsm.name} {

    node
        [shape=Mrecord width=1.5];
    ${maps/_map()}

}

// Local variables:
//  buffer-read-only: t
// End:
]],
        _map = [[

subgraph cluster_${map.name} {

    label=${map.name};

    //
    // States (Nodes)
    //
    ${states/_node_state()}
    ${popTrans/_node_pop()}
    ${needEnd?_node_end()}
    ${pushState/_node_push_state()}
    ${hasStart?_node_start()}
    ${pushEntry/_node_push_entry()}

    //
    // Transitions (Edges)
    //
    ${guards/_edge_guard()}
    ${popTrans/_edge_pop()}
    ${pushState/_edge_push_state()}
    ${hasStart?_edge_start()}
    ${pushEntry/_edge_push_entry()}

}
]],
            _node_state = [[

"${map.name}::${state.name}"
    [label="{${state.name}${generator.graphLevel1?_node_state1()}}"];
]],
                _node_state1 = "${hasEntryExit?_node_sep()}${entryActions?_node_entry()}${exitActions?_node_exit()}${internalEvents?_node_internal_events()}",
                    _node_sep = "|",
                    _node_entry = "Entry/\\l${entryActions/_indent_action()}",
                        _indent_action = "&nbsp;&nbsp;&nbsp;${_action()}",
                    _node_exit = "Exit/\\l${exitActions/_indent_action()}",
                    _node_internal_events = "|${internalEvents/_internal_guard()}",
                        _internal_guard = "${guard.transition.name}${generator.graphLevel2?_guard_params()}${generator.graphLevel1?_guard_cond()}/\\l${guard.actions/_indent_action()}${guard.doesPush?_indent_guard_push_action()}",
                            _indent_guard_push_action = "&nbsp;&nbsp;&nbsp;${_guard_push_action()}",
            _node_pop = [[

"${map.name}::pop(${pop})"
    [label="" width=1];
]],
            _node_end = [[

"${map.name}::%end"
    [label="" shape=doublecircle style=filled fillcolor=black width=0.15];
]],
            _node_push_state = [[

"${orig}"
    [label="{${guard.pushMapName}|O-O\r}"];
]],
            _node_start = [[

"%start"
    [label="" shape=circle style=filled fillcolor=black width=0.25];
]],
            _node_push_entry = [[

"${orig}"
    [label="" shape=plaintext];
]],
            _edge_guard = [[

"${orig}" -> "${dest}"
    [label="${guard.transition.name}${generator.graphLevel2?_guard_params()}${generator.graphLevel1?_guard_cond()}/\l${guard.actions/_action()}${guard.doesPush?_guard_push_action()}"];
]],
                _guard_params = "(${guard.transition.parameters/_parameter(); separator=', '})",
                _guard_cond = "${guard.hasCondition?_guard_cond_if()}",
                    _guard_cond_if = "\\l\\[${guard.condition; format=escape}\\]",
                    escape = escape,
                _guard_push_action = "push(${guard.pushState})\\l",
            _edge_pop = [[

"${map.name}::pop(${pop})" -> "${map.name}::%end"
    [label="pop(${pop});\l"];
]],
            _edge_push_state = [[

"${orig}" -> "${dest}"
    [label="pop/"]
]],
            _edge_start = [[

"%start" -> "${fsm.startState}"
]],
            _edge_push_entry = [[

"${orig}" -> "${dest}"
    [arrowtail=odot];
]],
        _action = "${generator.graphLevel1?_action1()}",
            _action1 = "${name}${generator.graphLevel2?_action2()};\\l",
                _action2 = "${propertyFlag?_action_prop()!_action_no_prop()}",
                    _action_prop = " = ${arguments; format=escape}",
                    _action_no_prop = "(${arguments; separator=', '; format=escape})",
        _parameter = "${name}${_type?_parameter_type()}",
            _parameter_type = ": ${_type}",
    }
end

