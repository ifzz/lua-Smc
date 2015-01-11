
require 'Coat'
local CodeGen = require 'CodeGen'

singleton 'Smc.Ooc'
extends 'Smc.Language'

has.id              = { '+', default = 'OOC' }
has.name            = { '+', default = 'Ooc' }
has.option          = { '+', default = '-ooc' }
has.suffix          = { '+', default = 'Context' }
has.generator       = { '+', isa = 'Smc.Ooc.Generator',
                        default = function () return require 'Smc.Ooc.Generator' end }
has.reflectFlag     = { '+', default = true }
has.noExceptionFlag = { '+', default = true }


class 'Smc.Ooc.Generator'
extends 'Smc.Generator'

has.suffix          = { '+', default = 'ooc' }

function method:_build_template ()
    return CodeGen{
        TOP = [[
// ex: set ro:
// DO NOT EDIT.
// generated by smc (http://github.com/fperrad/lua-Smc)
// from file : ${fsm.filename}

${_preamble()}
${_context()}
${_base_state()}
${fsm.maps/_map()}

// Local variables:
//  buffer-read-only: t
// End:
]],
        _preamble = [[
${fsm.source}

import statemap
${generator.reflectFlag?_preamble_reflect()}
import ${fsm._package?__package()}${fsm.context}
${fsm.importList/_import()}
]],
            _preamble_reflect = [[
import structs/ArrayList
import structs/HashMap
]],
            __package = "${fsm._package; format=scoped}/",
            _import = [[
import ${it}
]],
        _context = [[

${fsm.fsmClassname}: class extends FSMContext {
    owner: ${fsm.context} { get set }

    init: func (=owner) {
        super()
        setState(_${fsm.startState; format=scoped})
    }
    ${fsm.transitions/_transition_context()}

    enterStartState: func () {
        getState() Entry(this)
    }

    getState: func () -> ${fsm.context}State {
        return super() as TestClassState
    }
    ${generator.reflectFlag?_context_reflect()}
}
]],
            scoped = function (str) return str:gsub('::','_') end,
            _transition_context = "${isntDefault?_transition_context_if()}\n",
            _transition_context_if = [[

${name}: func (${parameters/_parameter_proto_context(); separator=", "}) {
    transition = "${name}"
    getState() ${name}(this${parameters/_parameter_call_context()})
    transition = ""
}
]],
                _parameter_proto_context = "${name}: ${_type}",
                _parameter_call_context = ", ${name}",
            _context_reflect = [[

states: ArrayList<${fsm.context}State> {
    get {
        l := ArrayList<${fsm.context}State> new()
        ${fsm.maps/_map_context_reflect()}
        return l
    }
}

transitions: ArrayList<String> {
    get {
        l := ArrayList<String> new()
        ${fsm.transitions/_transition_context_reflect()}
        return l
    }
}
]],
                _map_context_reflect = [[
${states/_state_context_reflect()}
]],
                     _state_context_reflect = [[
l add(_${map.name}_${name})
]],
                _transition_context_reflect = [[
l add("${name}")
]],
        _base_state = [[

${fsm.context}State: abstract class extends State {
    Entry: func (context: ${fsm.fsmClassname}) {}

    Exit: func (context: ${fsm.fsmClassname}) {}
    ${fsm.transitions/_transition_base_state()}

    Default: func (context: ${fsm.fsmClassname}) {
        ${generator.debugLevel0?_base_state_debug()}
        TransitionUndefinedException new(
            context getState() name,
            context transition
        ) throw()
    }
}
]],
            _transition_base_state = "${isntDefault?_transition_base_state_if()}\n",
            _transition_base_state_if = [[

${name}: func (context: ${fsm.fsmClassname}${parameters/_parameter_proto()}) {
    Default(context)
}
]],
                _parameter_proto = ", ${name}: ${_type}",
            _base_state_debug = [[
if (context debugFlag)
    fputs("TRANSITION   : Default()\n", context debugStream)

]],
        _map = [[

${name}_DefaultState: class extends ${fsm.context}State {
    init: func (=name, =id) {}
    ${defaultState?_map_default_state()}
    ${generator.reflectFlag?_default_state_reflect()}
}
${states/_state()}

${states/_state_init()}
_${name}_DefaultState := const ${name}_DefaultState new("${fullName}::DefaultState", -1)
]],
            _map_default_state = "${defaultState.transitions/_transition()}",
            _default_state_reflect = [[

transitions: HashMap<String, Int> {
    get {
        h := HashMap<String, Int> new()
        ${reflect/_reflect()}
        return h
    }
}
]],
            _state_init = [[
_${map.name}_${name} := const ${map.name}_${name} new("${fullName}", ${map.nextStateId})
]],
        _state = [[

${map.name}_${name}: class extends ${map.name}_DefaultState {
    init: func (=name, =id) {}
    ${entryActions?_state_entry()}
    ${exitActions?_state_exit()}
    ${transitions/_transition()}
    ${generator.reflectFlag?_state_reflect()}
}
]],
            _state_entry = [[

Entry: func (context: ${fsm.fsmClassname}) {
    ctxt := context owner

    ${entryActions/_action()}
}
]],
            _state_exit = [[

Exit: func (context: ${fsm.fsmClassname}) {
    ctxt := context owner

    ${exitActions/_action()}
}
]],
            _state_reflect = [[

transitions: HashMap<String, Int> {
    get {
        h := HashMap<String, Int> new()
        ${reflect/_reflect()}
        return h
    }
}
]],
                _reflect = [[
h put("${name}", ${def})
]],
        _transition = [[

${name}: func (context: ${fsm.fsmClassname}${parameters/_parameter_proto()}) {
    ${hasCtxtReference?_transition_ctxt()}
    ${generator.debugLevel0?_transition_debug()}
    ${guards/_guard()}
    ${needFinalElse?_transition_else()}
}
]],
            _transition_ctxt = [[
ctxt:= context owner

]],
            _transition_debug = [[
if (context debugFlag)
    fputs("LEAVING STATE   : ${state.fullName}\n", context debugStream)
]],
            _transition_else = [[
else {
    super(context${parameters/_parameter_call_context()})
}
]],
        _guard = "${isConditional?_guard_conditional()!_guard_unconditional()}",
            _guard_conditional = "${ifCondition?_guard_if()!_guard_no_if()}",
            _guard_no_if = "${elseifCondition?_guard_elseif()!_guard_else()}",
            _guard_unconditional = [[
${_guard_core()}
]],
            _guard_if = [[
if (${condition}) {
    ${_guard_core()}
}
]],
            _guard_elseif = [[

else if (${condition}) {
    ${_guard_core()}
}
]],
            _guard_else = [[

else {
    ${_guard_core()}
}
]],
                _guard_core = [[
${needVarEndState?_guard_end_state()}
${doesExit?_guard_exit()}
${generator.debugLevel0?_guard_debug_enter()}
${hasActions?_guard_actions()!_guard_no_action()}
${doesEndPop?_guard_end_pop()}
]],
                    _guard_end_state = [[
endState := context getState()
]],
                    _guard_exit = [[
${generator.debugLevel1?_guard_debug_before_exit()}
context getState() Exit(context)
${generator.debugLevel1?_guard_debug_after_exit()}
]],
                        _guard_debug_before_exit = [[
if (context debugFlag)
    fputs("BEFORE EXIT     : ${transition.state.fullName}.Exit()\n", context debugStream)
]],
                        _guard_debug_after_exit = [[
if (context debugFlag)
    fputs("AFTER EXIT      : ${transition.state.fullName}.Exit()\n", context debugStream)
]],
                    _guard_debug_enter = [[
if (context debugFlag)
    fputs("ENTER TRANSITION: ${transition.state.fullName}.${transition.name}(${transition.parameters/_guard_debug_param(); separator=', '})\n", context debugStream)
]],
                        _guard_debug_param = "${name}",
                    _guard_no_action = [[
${isConditional?_guard_no_action_if()}
${_guard_final()}
]],
                        _guard_no_action_if = [[
// No actions.
]],
                    _guard_actions = [[
context clearState()
${generator.catchFlag?_guard_actions_protected()!_guard_actions_not_protected()}
]],
                        _guard_actions_protected = [[
try {
    ${actions/_action()}
}
catch {}
${_guard_final()}
]],
                        _guard_actions_not_protected = [[
${actions/_action()}
${_guard_final()}
]],
                            _guard_final = [[
${generator.debugLevel0?_guard_debug_exit()}
${doesSet?_guard_set()}
${doesPush?_guard_push()}
${doesPop?_guard_pop()}
${doesEntry?_guard_entry()}
]],
                                _guard_debug_exit = [[
if (context debugFlag)
    fputs("EXIT TRANSITION : ${transition.state.fullName}.${transition.name}(${transition.parameters/_guard_debug_param(); separator=', '})\n", context debugStream)
]],
                                _guard_set = [[
context setState(${needVarEndState?_end_state_var()!_end_state_no_var()})
]],
                                    _end_state_var = "endState",
                                    _end_state_no_var = "_${endStateName; format=scoped}",
                                _guard_push = [[
${doesPushSet?_guard_set()}
${doesPushEntry?_guard_entry()}
context pushState(_${pushStateName; format=scoped})
]],
                                _guard_pop = [[
context popState()
]],
                                _guard_entry = [[
${generator.debugLevel1?_guard_debug_before_entry()}
context getState() Entry(context)
${generator.debugLevel1?_guard_debug_after_entry()}
]],
                                    _guard_debug_before_entry = [[
if (context debugFlag)
    fputs("BEFORE ENTRY    : ${transition.state.fullName}.Exit()\n", context debugStream)
]],
                                    _guard_debug_after_entry = [[
if (context debugFlag)
    fputs("AFTER ENTRY     : ${transition.state.fullName}.Exit()\n", context debugStream)
]],
                                _guard_end_pop = [[
context ${endStateName}(${popArgs})
]],
        _action = "${propertyFlag?_action_prop()!_action_no_prop()}\n",
            _action_no_prop = "${isEmptyStateStack?_action_ess()!_action_no_ess()}",
            _action_prop = [[
ctxt ${name} = ${arguments}
]],
                _action_ess = [[
context emptyStateStack()
]],
                _action_no_ess = [[
ctxt ${name}(${arguments; separator=', '})
]],
    }
end
