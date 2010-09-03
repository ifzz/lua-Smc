
require 'Coat'

singleton 'Smc.Ruby'
extends 'Smc.Language'

has.id              = { '+', default = 'RUBY' }
has.name            = { '+', default = 'Ruby' }
has.option          = { '+', default = '-ruby' }
has.suffix          = { '+', default = '_sm' }
has.generator       = { '+', isa = 'Smc.Ruby.Generator',
                        default = function () return require 'Smc.Ruby.Generator' end }
has.reflectFlag     = { '+', default = true }


class 'Smc.Ruby.Generator'
extends 'Smc.Generator'

has.suffix          = { '+', default = 'rb' }

function method:_build_template ()
    return CodeGen{
        TOP = [[
# ex: set ro:
# DO NOT EDIT.
# generated by smc (http://github.com/fperrad/lua-Smc)
# from file : ${fsm.filename}

${_preamble()}
${_base_state()}
${fsm.maps:_map()}
${_context()}

# Local variables:
#  buffer-read-only: t
# End:
]],
        _preamble = [[
${fsm.source}
require 'statemap'
${fsm.importList:_import()}
]],
            _import = "require '${it}'\n",
        _base_state = [[

class ${fsm.context}State < Statemap::State

    def Entry(fsm) end

    def Exit(fsm) end

    def method_missing(name, *args)
        fsm = args.shift
        Default(fsm)
    end

    def Default(fsm)
        ${generator.debugLevel0?_base_state_debug()}
        msg = "\nState: " + fsm.getState.getName +
              "\nTransition: " + fsm.getTransition.to_s + "\n"
        raise Statemap::TransitionUndefinedException, msg
    end

end
]],
            _base_state_debug = [[
if fsm.getDebugFlag then
    fsm.getDebugStream.write("TRANSITION   : Default\n")
end
]],
        _map = [[

class ${name}_Default < ${fsm.context}State
    ${defaultState?_map_default_state()}
    ${generator.reflectFlag?_state_reflect()}

end
${states:_state()}

module ${name}
    ${states:_state_init()}
    Default = ${name}_Default::new('${name}.Default', -1).freeze
end
]],
            _map_default_state = "${defaultState.transitions:_transition()}",
            _state_init = "${instanceName} = ${map.name}_${className}::new('${map.name}.${className}', ${map.nextStateId}).freeze\n",
        _state = [[

class ${map.name}_${className} < ${map.name}_Default
    ${entryActions?_state_entry()}
    ${exitActions?_state_exit()}
    ${transitions:_transition()}
    ${generator.reflectFlag?_state_reflect()}

end
]],
            _state_entry = [[

def Entry(fsm)
    ctxt = fsm.getOwner
    ${entryActions:_action()}
end
]],
            _state_exit = [[

def Exit(fsm)
    ctxt = fsm.getOwner
    ${exitActions:_action()}
end
]],
            _state_reflect = [[

def getTransitions()
    return {
        ${reflect:_reflect()}
    }
end
]],
                _reflect = "'${name}' => ${def},\n",
        _transition = [[

def ${name}(fsm${parameters:_parameter_proto()})
    ${hasCtxtReference?_transition_ctxt()}
    ${generator.debugLevel0?_transition_debug()}
    ${guards:_guard()}
    ${needFinalElse?_transition_else()}
    ${needFinalEnd?_transition_end()}
end
]],
            _parameter_proto = ", ${name}",
            _transition_ctxt = [[
ctxt = fsm.getOwner
]],
            _transition_debug = [[
if fsm.getDebugFlag then
    fsm.getDebugStream.write("LEAVING STATE   : ${state.map.name}.${state.className}\n")
end
]],
            _transition_else = [[
else
    super
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

elsif ${condition} then
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
${doesEndPop?_guard_end_pop()}
]],
                _guard_end_state = "${varEndState} = fsm.getState",
                _guard_exit = [[
${generator.debugLevel1?_guard_debug_before_exit()}
fsm.getState.Exit(fsm)
${generator.debugLevel1?_guard_debug_after_exit()}
]],
                    _guard_debug_before_exit = [[
if fsm.getDebugFlag then
    fsm.getDebugStream.write("BEFORE EXIT     : ${transition.state.fullName}.Exit(fsm)\n")
end
]],
                    _guard_debug_after_exit = [[
if fsm.getDebugFlag then
    fsm.getDebugStream.write("AFTER EXIT      : ${transition.state.fullName}.Exit(fsm)\n")
end
]],
                _guard_debug_enter = [[
if fsm.getDebugFlag then
    fsm.getDebugStream.write("ENTER TRANSITION: ${transition.state.fullName}.${transition.name}(${transition.parameters:_guard_debug_param(); separator=', '})\n")
end
]],
                    _guard_debug_param = "${name}",
                _guard_no_action = [[
${hasCondition?_guard_no_action_if()}
${_guard_final()}
]],
                    _guard_no_action_if = "# No actions.\n",
                _guard_actions = [[
fsm.clearState
${generator.catchFlag?_guard_actions_protected()!_guard_actions_not_protected()}
]],
                    _guard_actions_protected = [[
begin
    ${actions:_action()}
${generator.debugLevel0?_guard_debug_exception()}
ensure
    ${_guard_final()}
end
]],
                        _guard_debug_exception = [[
rescue RuntimeError => e
    fsm.getDebugStream.write e
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
if fsm.getDebugFlag then
    fsm.getDebugStream.write("EXIT TRANSITION : ${transition.state.fullName}.${transition.name}(${transition.parameters:_guard_debug_param(); separator=', '})\n")
end
]],
                _guard_set = "fsm.setState(${varEndState; format=scoped})",
                scoped = function (s) return s:gsub("%.", "::") end,
                _guard_push = [[
${doesPushSet?_guard_set()}
${doesPushEntry?_guard_entry()}
fsm.pushState(${pushStateName; format=scoped})
]],
                _guard_pop = "fsm.popState()",
                _guard_entry = [[
${generator.debugLevel1?_guard_debug_before_entry()}
fsm.getState.Entry(fsm)
${generator.debugLevel1?_guard_debug_after_entry()}
]],
                    _guard_debug_before_entry = [[
if fsm.getDebugFlag then
    fsm.getDebugStream.write("BEFORE ENTRY    : ${transition.state.fullName}.Entry(fsm)\n")
end
]],
                    _guard_debug_after_entry = [[
if fsm.getDebugFlag then
    fsm.getDebugStream.write("AFTER ENTRY     : ${transition.state.fullName}.Entry(fsm)\n")
end
]],
                _guard_end_pop = "fsm.${endStateName}(${popArgs})",
        _action = "${propertyFlag?_action_prop()!_action_no_prop()}\n",
            _action_prop = "ctxt.${name} = ${arguments}",
            _action_no_prop = "${isEmptyStateStack?_action_ess()!_action_no_ess()}",
            _action_ess = "fsm.emptyStateStack()",
            _action_no_ess = "ctxt.${name}(${arguments; separator=', '})",
        _context = [[

class ${fsm.context}_sm < Statemap::FSMContext

    def initialize(owner)
        super(${fsm.startState})
        @_owner = owner
    end

    def enterStartState()
        getState.Entry(self)
    end

    def method_missing(name, *args)
        @_transition = name
        getState.send(name, self, *args)
        @_transition = nil
    end

    def getOwner()
        return @_owner
    end

    ${generator.reflectFlag?_context_reflect()}
end
]],
            _context_reflect = [[
def getStates()
    return [
        ${fsm.maps:_map_context_reflect()}
    ]
end

def getTransitions()
    return [
        ${fsm.transitions:_transition_context_reflect()}
    ]
end

]],
                _map_context_reflect = "${states:_state_context_reflect()}\n",
                     _state_context_reflect = "${map.name}::${className},\n",
                _transition_context_reflect = "'${name}',\n",
    }
end
