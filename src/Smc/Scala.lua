
require 'Coat'

local ipairs = ipairs

singleton 'Smc.Scala'
extends 'Smc.Language'

has.id              = { '+', default = 'SCALA' }
has.name            = { '+', default = 'Scala' }
has.option          = { '+', default = '-scala' }
has.suffix          = { '+', default = 'Context' }
has.generator       = { '+', isa = 'Smc.Scala.Generator',
                        default = function () return require 'Smc.Scala.Generator' end }
has.reflectFlag     = { '+', default = true }
has.serialFlag      = { '+', default = true }
has.syncFlag        = { '+', default = true }


class 'Smc.Scala.Generator'
extends 'Smc.Generator'

has.suffix          = { '+', default = 'scala' }

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
${fsm.maps:_map()}

// Local variables:
//  buffer-read-only: t
// End:
]],
        _preamble = [[
${fsm.source}
${fsm._package?__package()}
${generator.syncFlag?_concurrent()}

${fsm.importList:_import()}
]],
            __package = [[

package ${fsm._package; format=scoped}
]],
            _concurrent = [[

import scala.concurrent
]],
            _import = [[
import ${it}
]],
        _context = [[

${generator.serialFlag?_serializable()}
class ${fsm.fsmClassname}(owner: ${fsm.context}) extends statemap.FSMContext[${fsm.context}State] {
    private val _owner: ${fsm.context} = owner

    setState(${fsm.startState; format=scoped})
    ${fsm.transitions:_transition_context()}

    override def enterStartState(): Unit = {
        getState().Entry(this)
    }

    def getOwner(): ${fsm.context} = _owner
    ${generator.reflectFlag?_context_reflect()}
}
]],
            scoped = function (str) return str:gsub('::','.') end,
            _serializable = [[
@serializable
]],
            _transition_context = "${isntDefault?_transition_context_if()}\n",
            _transition_context_if = [[

def ${name} (${parameters:_parameter_proto_context(); separator=", "}): Unit = ${generator.syncFlag?_synchronized()}{
    _transition = "${name}"
    getState().${name}(this${parameters:_parameter_call_context()})
    _transition = ""
}
]],
                _synchronized = "synchronized ",
                _parameter_proto_context = "${name}: ${_type}",
                _parameter_call_context = ", ${name}",
            _context_reflect = [[

def getStates(): List[${fsm.context}State] = List(
    ${fsm.maps:_map_context_reflect(); separator=",\n"}
)

def getTransitions(): List[String] = List(
    ${fsm.transitions:_transition_context_reflect(); separator=",\n"}
)
]],
                _map_context_reflect = '${states:_state_context_reflect(); separator=",\\n"}',
                     _state_context_reflect = [[
${map.name}.${className}
]],
                _transition_context_reflect = [[
"${name}"
]],
        _base_state = [[

${generator.serialFlag?_serializable()}
class ${fsm.context}State(name: String, id: Int) {
    private val _name = name
    private val _id = id

    def getName(): String = _name

    override def toString(): String = _name

    def Entry(context: ${fsm.fsmClassname}): Unit = {}
    def Exit(context: ${fsm.fsmClassname}): Unit = {}
    ${fsm.transitions:_transition_base_state()}

    def Default(context: ${fsm.fsmClassname}): Unit = {
        ${generator.debugLevel0?_base_state_debug()}
        throw new statemap.TransitionUndefinedException(
                "State: " + context.getState()._name +
                ", Transition: " + context.getTransition())
    }
}
]],
            _transition_base_state = "${isntDefault?_transition_base_state_if()}\n",
            _transition_base_state_if = [[

def ${name}(context: ${fsm.fsmClassname}${parameters:_parameter_proto()}): Unit = {
    Default(context)
}
]],
                _parameter_proto = ", ${name}: ${_type}",
            _base_state_debug = [[
if (context.getDebugFlag())
    context.getDebugStream().println("TRANSITION   : Default")

]],
        _map = [[

private class ${name}_Default(name: String, id: Int) extends ${fsm.context}State(name, id) {
    ${defaultState?_map_default_state()}
    ${generator.reflectFlag?_default_state_reflect()}
}
${states:_state()}

private object ${name} {
    ${states:_state_init()}
    val Default = new ${name}_Default("${name}.Default", -1)
}
]],
            _map_default_state = "${defaultState.transitions:_transition()}",
            _default_state_reflect = [[

def getTransitions(): Map[String, Int] = Map(
    ${reflect:_reflect(); separator=",\n"}
)
]],
            _state_init = [[
val ${instanceName} = new ${map.name}_${className}("${map.name}.${className}", ${map.nextStateId})
]],
        _state = [[

private class ${map.name}_${className}(name: String, id: Int) extends ${map.name}_Default(name, id) {
    ${entryActions?_state_entry()}
    ${exitActions?_state_exit()}
    ${transitions:_transition()}
    ${generator.reflectFlag?_state_reflect()}
}
]],
            _state_entry = [[

override def Entry (context: ${fsm.fsmClassname}): Unit = {
    val ctxt = context.getOwner()

    ${entryActions:_action()}
}
]],
            _state_exit = [[

override def Exit (context: ${fsm.fsmClassname}): Unit = {
    val ctxt = context.getOwner()

    ${exitActions:_action()}
}
]],
            _state_reflect = [[

override def getTransitions(): Map[String, Int] = Map(
    ${reflect:_reflect(); separator=",\n"}
)
]],
                _reflect = [["${name}" -> ${def}]],
        _transition = [[

override def ${name}(context: ${fsm.fsmClassname}${parameters:_parameter_proto()}): Unit = {
    ${hasCtxtReference?_transition_ctxt()}
    ${generator.debugLevel0?_transition_debug()}
    ${guards:_guard()}
    ${needFinalElse?_transition_else()}
}
]],
            _transition_ctxt = [[
val ctxt: ${fsm.context} = context.getOwner()

]],
            _transition_debug = [[
if (context.getDebugFlag())
    context.getDebugStream().println("LEAVING STATE   : ${state.map.name}.${state.className}")
]],
            _transition_else = [[
else {
    super.${name}(context${parameters:_parameter_proto()})
}
]],
        _guard = "${hasCondition?_guard_conditional()!_guard_unconditional()}",
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
val endState = context.getState()
]],
                    _guard_exit = [[
${generator.debugLevel1?_guard_debug_before_exit()}
context.getState().Exit(context)
${generator.debugLevel1?_guard_debug_after_exit()}
]],
                        _guard_debug_before_exit = [[
if (context.getDebugFlag())
    context.getDebugStream().println("BEFORE EXIT     : ${transition.state.fullName}.Exit(fsm)")
]],
                        _guard_debug_after_exit = [[
if (context.getDebugFlag())
    context.getDebugStream().println("AFTER EXIT      : ${transition.state.fullName}.Exit(fsm)")
]],
                    _guard_debug_enter = [[
if (context.getDebugFlag())
    context.getDebugStream().println("ENTER TRANSITION: ${transition.state.fullName}.${transition.name}(${transition.parameters:_parameter_proto_context(); separator=', '})")
]],
                    _guard_no_action = [[
${hasCondition?_guard_no_action_if()}
${_guard_final()}
]],
                        _guard_no_action_if = [[
// No actions.
]],
                    _guard_actions = [[
context.clearState()
${generator.catchFlag?_guard_actions_protected()!_guard_actions_not_protected()}
]],
                        _guard_actions_protected = [[
try {
    ${actions:_action()}
}
finally {
    ${_guard_final()}
}
]],
                        _guard_actions_not_protected = [[
${actions:_action()}
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
if (context.getDebugFlag())
    context.getDebugStream().println("EXIT TRANSITION : ${transition.state.fullName}.${transition.name}(${transition.parameters:_parameter_proto_context(); separator=', '})")
]],
                                _guard_set = [[
context.setState(${needVarEndState?_end_state_var()!_end_state_no_var()})
]],
                                    _end_state_var = "endState",
                                    _end_state_no_var = "${endStateName; format=scoped}",
                                _guard_push = [[
${doesPushSet?_guard_set()}
${doesPushEntry?_guard_entry()}
context.pushState(${pushStateName; format=scoped})
]],
                                _guard_pop = [[
context.popState()
]],
                                _guard_entry = [[
${generator.debugLevel1?_guard_debug_before_entry()}
context.getState().Entry(context)
${generator.debugLevel1?_guard_debug_after_entry()}
]],
                                    _guard_debug_before_entry = [[
if (context.getDebugFlag())
    context.getDebugStream().println("BEFORE ENTRY    : ${transition.state.fullName}.Exit(fsm)")
]],
                                    _guard_debug_after_entry = [[
if (context.getDebugFlag())
    context.getDebugStream().println("AFTER ENTRY     : ${transition.state.fullName}.Exit(fsm)")
]],
                                _guard_end_pop = [[
context.${endStateName}(${popArgs})
]],
        _action = "${propertyFlag?_action_prop()!_action_no_prop()}\n",
            _action_no_prop = "${isEmptyStateStack?_action_ess()!_action_no_ess()}",
            _action_prop = [[
ctxt.${name} = ${arguments}
]],
                _action_ess = [[
context.emptyStateStack()
]],
                _action_no_ess = [[
ctxt.${name}(${arguments; separator=', '})
]],
    }
end
