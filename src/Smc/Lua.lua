
require 'Coat'
require 'CodeGen'

singleton 'Smc.Lua'
extends 'Smc.Language'

has.id              = { '+', default = 'LUA' }
has.name            = { '+', default = 'Lua' }
has.option          = { '+', default = '-lua' }
has.suffix          = { '+', default = '_sm' }
has.generator       = { '+', isa = 'Smc.Lua.Generator',
                        default = function () return require 'Smc.Lua.Generator' end }
has.reflectFlag     = { '+', default = true }


class 'Smc.Lua.Generator'
extends 'Smc.Generator'

has.suffix          = { '+', default = 'lua' }

function method:_build_template ()
    return CodeGen{
        TOP = [[
-- ex: set ro:
-- DO NOT EDIT.
-- from file : ${fsm.filename}

${_preamble()}
${_default_state()}
${_states()}
${_context()}

-- Local variables:
--  buffer-read-only: t
-- End:
]],
        _preamble = [[
local error = error
${generator.catchFlag?_local_pcall()}
${generator.debugLevel0?_local_tostring()}
local strformat = require 'string'.format

local statemap = require 'statemap'
${fsm.source}
${fsm.importList:_import()}

module(...)
]],
            _local_pcall = "local pcall = pcall",
            _local_tostring = "local tostring = tostring",
            _import = "require '${it}'\n",
        _default_state = [[

local ${fsm.context}State = statemap.State:class()

function ${fsm.context}State:Entry (fsm) end

function ${fsm.context}State:Exit (fsm) end
${fsm.transitions:_transition_default_state()}

function ${fsm.context}State:Default (fsm)
${generator.debugLevel0?_default_state_debug()}
    local msg = strformat("Undefined Transition\nState: %s\nTransition: %s\n",
                          fsm:getState():getName(),
                          fsm:getTransition())
    error(msg)
end
${generator.reflectFlag?_default_state_reflect()}
]],
            _transition_default_state = "${isntDefault?_transition_default_state_if()}\n",
            _transition_default_state_if = [[

function ${fsm.context}State:${name} (fsm${parameters:_parameter_proto()})
    self:Default(fsm)
end
]],
                _parameter_proto = ", ${name}",
            _default_state_debug = [[
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("TRANSITION   : Default\n")
    end
]],
            _default_state_reflect = [[

function ${fsm.context}State:getTransitions ()
    return self._transitions
end
]],
        _states = [[

${fsm.maps:_map_local()}
${fsm.maps:_map()}
]],
            _map_local = "local ${name} = {}\n",
            _map = [[

${name}.Default = ${fsm.context}State:new('${name}.Default', -1)
${defaultState?_map_default_state()}
${generator.reflectFlag?_map_reflect()}
${states:_state()}
]],
                _map_default_state = "${defaultState.transitions:_transition()}",
                _map_reflect = [[

${name}.Default._transitions = {
    ${fsm.transitions:_transition_default_reflect()}
}
]],
                    _transition_default_reflect = "${name} = '${name}', --FIXME\n",
                _state = [[

${map.name}.${className} = ${map.name}.Default:new('${map.name}.${className}', ${map.nextStateId})
${entryActions?_state_entry()}
${exitActions?_state_exit()}
${transitions:_transition()}
${generator.reflectFlag?_state_reflect()}
]],
                    _state_entry = [[

function ${map.name}.${className}:Entry (fsm)
    local ctxt = fsm:getOwner()
    ${entryActions:_action()}
end
]],
                    _state_exit = [[

function ${map.name}.${className}:Exit (fsm)
    local ctxt = fsm:getOwner()
    ${exitActions:_action()}
end
]],
                    _state_reflect = [[

${map.name}.${className}._transitions = {
    ${fsm.transitions:_transition_reflect()}
}
]],
                        _transition_reflect = "${name} = '${name}', --FIXME\n",
                    _transition = [[

function ${state.map.name}.${state.className}:${name} (fsm${parameters:_parameter_proto()})
${hasCtxtReference?_transition_ctxt()}
${generator.debugLevel0?_transition_debug()}
${guards:_guard()}
${needFinalElse?_transition_else()}
${needFinalEnd?_transition_end()}
end
]],
                        _transition_ctxt = [[
    local ctxt = fsm:getOwner()
]],
                        _transition_debug = [[
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ${map.name}.${state.className}\n")
    end
]],
                        _transition_else = [[
    else
        ${map.name}.Default:${name}(fsm${parameters:_parameter_proto()})
    end
]],
                        _transition_end = [[
    end
]],
                        _guard = "${hasCondition?_guard_conditional()!_guard_unconditional()}",
                        _guard_conditional = "${ifCondition?_guard_if()!_guard_no_if()}",
                        _guard_no_if = "${elseifCondition?_guard_elseif()!_guard_else()}",
                        _guard_unconditional = [[
    ${_guard_core()}
]],
                        _guard_if = [[
    if ${condition} then
        ${_guard_core()}
]],
                        _guard_elseif = [[

    elseif ${condition} then
        ${_guard_core()}
]],
                        _guard_else = [[

    else
        ${_guard_core()}
]],
                            _guard_core = [[
${needVarEndState?_guard_end_state()}
${doesExit?_guard_exit()}
${generator.debugLevel0?_guard_debug_enter()}
${hasActions?_guard_actions()!_guard_no_action()}
${generator.debugLevel0?_guard_debug_exit()}
${doesSet?_guard_set()}
${doesPush?_guard_push()}
${doesPop?_guard_pop()}
${doesEntry?_guard_entry()}
${doesEndPop?_guard_end_pop()}
]],
                                _guard_end_state = "local ${varEndState} = fsm:getState()",
                                _guard_exit = [[
${generator.debugLevel1?_guard_debug_before_exit()}
fsm:getState():Exit(fsm)
${generator.debugLevel1?_guard_debug_after_exit()}
]],
                                    _guard_debug_before_exit = [[
if fsm:getDebugFlag() then
    fsm:getDebugStream():write("BEFORE EXIT     : ${transition.state.fullName}.Exit(fsm)\n")
end
]],
                                    _guard_debug_after_exit = [[
if fsm:getDebugFlag() then
    fsm:getDebugStream():write("AFTER EXIT      : ${transition.state.fullName}.Exit(fsm)\n")
end
]],
                                _guard_debug_enter = [[
if fsm:getDebugFlag() then
    fsm:getDebugStream():write("ENTER TRANSITION: ${transition.state.fullName}:${transition.name}(${transition.parameters:_guard_debug_param(); separator=', '})\n")
end
]],
                                    _guard_debug_param = [[${name}=" .. tostring(${name}) .. "]],
                                _guard_no_action = "${hasCondition?_guard_no_action_if()}\n",
                                _guard_no_action_if = "-- No actions.\n",
                                _guard_actions = [[
fsm:clearState()
${generator.catchFlag?_guard_actions_protected()!_guard_actions_not_protected()}
]],
                                    _guard_actions_protected = [[
local r, msg = pcall(
    function ()
        ${actions:_action()}
    end
)
${generator.debugLevel1?_guard_debug_exception()}
]],
                                        _guard_debug_exception = [[
if not r then
    fsm:getDebugStream():write(msg)
end
]],
                                    _guard_actions_not_protected = "${actions:_action()}",
                                _guard_debug_exit = [[
if fsm:getDebugFlag() then
    fsm:getDebugStream():write("EXIT TRANSITION: ${transition.state.fullName}:${transition.name}(${transition.parameters:_guard_debug_param(); separator=', '})\n")
end
]],
                                _guard_set = "fsm:setState(${varEndState})",
                                _guard_push = [[
${doesPushSet?_guard_set()}
${doesPushEntry?_guard_entry()}
fsm:pushState(${pushStateName})
]],
                                    _guard_push_entry = [[
${generator.debugLevel1?_guard_debug_before_entry()}
fsm:getState():Entry(fsm)
${generator.debugLevel1?_guard_debug_after_entry()}
]],
                                _guard_pop = "fsm:popState()",
                                _guard_entry = [[
${generator.debugLevel1?_guard_debug_before_entry()}
fsm:getState():Entry(fsm)
${generator.debugLevel1?_guard_debug_after_entry()}
]],
                                    _guard_debug_before_entry = [[
if fsm:getDebugFlag() then
    fsm:getDebugStream():write("BEFORE ENTRY    : ${transition.state.fullName}.Entry(fsm)\n")
end
]],
                                    _guard_debug_after_entry = [[
if fsm:getDebugFlag() then
    fsm:getDebugStream():write("AFTER ENTRY     : ${transition.state.fullName}.Entry(fsm)\n")
end
]],
                                _guard_end_pop = "fsm:${endStateName}(${popArgs})",
                            _action = "${propertyFlag?_action_prop()!_action_no_prop()}\n",
                            _action_prop = "ctxt.${name} = ${arguments}",
                            _action_no_prop = "${isEmptyStateStack?_action_ess()!_action_no_ess()}",
                            _action_ess = "fsm:emptyStateStack()",
                            _action_no_ess = "ctxt:${name}(${arguments; separator=', '})",
        _context = [[

${fsm.fsmClassname} = statemap.FSMContext:class()

function ${fsm.fsmClassname}:_init ()
    self:setState(${fsm.startState; format=scoped})
end
${fsm.transitions:_transition_context()}

function ${fsm.fsmClassname}:enterStartState ()
    self:getState():Entry(self)
end

function ${fsm.fsmClassname}:getOwner ()
    return self._owner
end
${generator.reflectFlag?_context_reflect()}
]],
            scoped = function (str) return str:gsub('::','.') end,
            _transition_context = "${isntDefault?_transition_context_if()}\n",
            _transition_context_if = [[

function ${fsm.fsmClassname}:${name} (${hasParameters?_transition_context_param1()})
    self._transition = '${name}'
    self:getState():${name}(self${hasParameters?_transition_context_param2()})
    self._transition = nil
end
]],
                _transition_context_param1 = "...",
                _transition_context_param2 = ", ...",
            _context_reflect = [[

${fsm.fsmClassname}._States = {
    ${fsm.maps:_map_context_reflect()}
}
function ${fsm.fsmClassname}:getStates ()
    return self._States
end

${fsm.fsmClassname}._transitions = {
    ${fsm.transitions:_transition_context_reflect()}
}
function ${fsm.fsmClassname}:getTransitions ()
    return self._transitions
end
]],
                _map_context_reflect = "${states:_state_context_reflect()}\n",
                     _state_context_reflect = "${map.name}.${className},\n",
                _transition_context_reflect = "'${name}',\n"
    }
end

