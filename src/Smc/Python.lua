
require 'Coat'
local CodeGen = require 'CodeGen'

singleton 'Smc.Python'
extends 'Smc.Language'

has.id              = { '+', default = 'PYTHON' }
has.name            = { '+', default = 'Python' }
has.option          = { '+', default = '-python' }
has.suffix          = { '+', default = '_sm' }
has.generator       = { '+', isa = 'Smc.Python.Generator',
                        default = function () return require 'Smc.Python.Generator' end }
has.reflectFlag     = { '+', default = true }


class 'Smc.Python.Generator'
extends 'Smc.Generator'

has.suffix          = { '+', default = 'py' }

function method:_build_template ()
    return CodeGen{
        TOP = [[
# ex: set ro:
# DO NOT EDIT.
# generated by smc (http://github.com/fperrad/lua-Smc)
# from file : ${fsm.filename}

${_preamble()}
${_base_state()}
${fsm.maps/_map()}
${_context()}

# Local variables:
#  buffer-read-only: t
# End:
]],
        _preamble = [[
${fsm.source}
import statemap
${fsm.importList/_import()}
]],
            _import = [[
import ${it}
]],
        _base_state = [[

class ${fsm.context}State(statemap.State):

    def Entry(self, fsm):
        pass

    def Exit(self, fsm):
        pass
    ${fsm.transitions/_transition_base_state()}

    def Default(self, fsm):
        ${generator.debugLevel0?_base_state_debug()}
        msg = "\n\tState: %s\n\tTransition: %s" % (
            fsm.getState().getName(), fsm.getTransition()
        )
        raise statemap.TransitionUndefinedException, msg
    ${generator.reflectFlag?_base_state_reflect()}
]],
            _transition_base_state = "${isntDefault?_transition_base_state_if()}\n",
            _transition_base_state_if = [[

def ${name}(self, fsm${parameters/_parameter_proto()}):
    self.Default(fsm)
]],
                _parameter_proto = ", ${name}",
            _base_state_debug = [[
if fsm.getDebugFlag() == True:
    fsm.getDebugStream().write('TRANSITION   : Default()\n')
]],
            _base_state_reflect = [[

def getTransitions (self):
    return self._transitions
]],
        _map = [[

class ${name}_DefaultState(${fsm.context}State):
    pass
    ${defaultState?_map_default_state()}
    ${generator.reflectFlag?_state_reflect()}

${states/_state()}

class ${name}(object):
    ${states/_state_init()}
    DefaultState = ${name}_DefaultState('${fullName}::DefaultState', -1)
]],
            _map_default_state = "${defaultState.transitions/_transition()}",
            _state_init = [[
${name} = ${map.name}_${name}('${fullName}', ${map.nextStateId})
]],
        _state = [[

class ${map.name}_${name}(${map.name}_DefaultState):
    pass
    ${entryActions?_state_entry()}
    ${exitActions?_state_exit()}
    ${transitions/_transition()}
    ${generator.reflectFlag?_state_reflect()}
]],
            _state_entry = [[

def Entry(self, fsm):
    ctxt = fsm.getOwner()
    ${entryActions/_action()}
]],
            _state_exit = [[

def Exit(self, fsm):
    ctxt = fsm.getOwner()
    ${exitActions/_action()}
]],
            _state_reflect = [[

_transitions = dict(
    ${reflect/_reflect()}
)
]],
                _reflect = [[
${name} = ${def},
]],
        _transition = [[

def ${name}(self, fsm${parameters/_parameter_proto()}):
    ${hasCtxtReference?_transition_ctxt()}
    ${generator.debugLevel0?_transition_debug()}
    ${guards/_guard()}
    ${needFinalElse?_transition_else()}
]],
            _parameter_proto = ", ${name}",
            _transition_ctxt = [[
ctxt = fsm.getOwner()
]],
            _transition_debug = [[
if fsm.getDebugFlag() == True:
    fsm.getDebugStream().write("LEAVING STATE   : ${state.fullName}\n")
]],
            _transition_else = [[
else:
    ${state.map.name}_DefaultState.${name}(self, fsm${parameters/_parameter_proto()})
]],
        _guard = "${isConditional?_guard_conditional()!_guard_unconditional()}",
            _guard_conditional = "${ifCondition?_guard_if()!_guard_no_if()}",
            _guard_no_if = "${elseifCondition?_guard_elseif()!_guard_else()}",
            _guard_unconditional = [[
${_guard_core()}
]],
            _guard_if = [[
if ${condition}:
    ${_guard_core()}
]],
            _guard_elseif = [[

elif ${condition}:
    ${_guard_core()}
]],
            _guard_else = [[

else:
    ${_guard_core()}
]],
            _guard_core = [[
${needVarEndState?_guard_end_state()}
${doesExit?_guard_exit()}
${generator.debugLevel0?_guard_debug_enter()}
${hasActions?_guard_actions()!_guard_no_action()}
${doesEndPop?_guard_end_pop()}
]],
                _guard_end_state = [[
endState = fsm.getState()
]],
                _guard_exit = [[
${generator.debugLevel1?_guard_debug_before_exit()}
fsm.getState().Exit(fsm)
${generator.debugLevel1?_guard_debug_after_exit()}
]],
                    _guard_debug_before_exit = [[
if fsm.getDebugFlag() == True:
    fsm.getDebugStream().write("BEFORE EXIT     : ${transition.state.fullName}.Exit()\n")
]],
                    _guard_debug_after_exit = [[
if fsm.getDebugFlag() == True:
    fsm.getDebugStream().write("AFTER EXIT      : ${transition.state.fullName}.Exit()\n")
]],
                _guard_debug_enter = [[
if fsm.getDebugFlag() == True:
    fsm.getDebugStream().write("ENTER TRANSITION: ${transition.state.fullName}.${transition.name}(${transition.parameters/_guard_debug_param(); separator=', '})\n")
]],
                    _guard_debug_param = "${name}",
                _guard_no_action = [[
# No actions
pass
${_guard_final()}
]],
                _guard_actions = [[
fsm.clearState()
${generator.catchFlag?_guard_actions_protected()!_guard_actions_not_protected()}
]],
                    _guard_actions_protected = [[
try:
    ${actions/_action()}
finally:
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
if fsm.getDebugFlag() == True:
    fsm.getDebugStream().write("EXIT TRANSITION : ${transition.state.fullName}.${transition.name}(${transition.parameters/_guard_debug_param(); separator=', '})\n")
]],
                _guard_set = [[
fsm.setState(${needVarEndState?_end_state_var()!_end_state_no_var()})
]],
                    _end_state_var = "endState",
                    _end_state_no_var = "${endStateName; format=scoped}",
                _guard_push = [[
${doesPushSet?_guard_set()}
${doesPushEntry?_guard_entry()}
fsm.pushState(${pushStateName; format=scoped})
]],
                _guard_pop = [[
fsm.popState()
]],
                _guard_entry = [[
${generator.debugLevel1?_guard_debug_before_entry()}
fsm.getState().Entry(fsm)
${generator.debugLevel1?_guard_debug_after_entry()}
]],
                    _guard_debug_before_entry = [[
if fsm.getDebugFlag() == True:
    fsm.getDebugStream().write("BEFORE ENTRY    : ${transition.state.fullName}.Entry()\n")
]],
                    _guard_debug_after_entry = [[
if fsm.getDebugFlag() == True:
    fsm.getDebugStream().write("AFTER ENTRY     : ${transition.state.fullName}.Entry()\n")
]],
                _guard_end_pop = [[
fsm.${endStateName}(${popArgs})
]],
        _action = "${propertyFlag?_action_prop()!_action_no_prop()}\n",
            _action_no_prop = "${isEmptyStateStack?_action_ess()!_action_no_ess()}",
            _action_prop = [[
ctxt.${name} = ${arguments}
]],
            _action_ess = [[
fsm.emptyStateStack()
]],
            _action_no_ess = [[
ctxt.${name}(${arguments; separator=', '})
]],
        _context = [[

class ${fsm.context}_sm(statemap.FSMContext):

    def __init__(self, owner):
        statemap.FSMContext.__init__(self, ${fsm.startState; format=scoped})
        self._owner = owner

    def __getattr__(self, attrib):
        def trans_sm(*arglist):
            self._transition = attrib
            getattr(self.getState(), attrib)(self, *arglist)
            self._transition = None
        return trans_sm

    def enterStartState(self):
        self._state.Entry(self)

    def getOwner(self):
        return self._owner

    ${generator.reflectFlag?_context_reflect()}
]],
            scoped = function (str) return str:gsub('::','.') end,
            _context_reflect = [[
_States = (
    ${fsm.maps/_map_context_reflect()}
)
def getStates(self):
    return self._States

_transitions = (
    ${fsm.transitions/_transition_context_reflect()}
)
def getTransitions(self):
    return self._transitions

]],
                _map_context_reflect = "${states/_state_context_reflect()}\n",
                     _state_context_reflect = [[
${map.name}.${name},
]],
                _transition_context_reflect = [[
'${name}',
]],
    }
end
