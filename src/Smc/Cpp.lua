
require 'Coat'
local CodeGen = require 'CodeGen'

singleton 'Smc.Cpp'
extends 'Smc.Language'

has.id              = { '+', default = 'C_PLUS_PLUS' }
has.name            = { '+', default = 'C++' }
has.option          = { '+', default = '-c++' }
has.suffix          = { '+', default = '_sm' }
has.generator       = { '+', isa = 'Smc.Cpp.Generator',
                        default = function () return require 'Smc.Cpp.Generator' end }
has.castFlag        = { '+', default = true }
has.headerFlag      = { '+', default = true }
has.noExceptionFlag = { '+', default = true }
has.noStreamFlag    = { '+', default = true }
has.serialFlag      = { '+', default = true }
has.castTypes       = { '+', default = {
                                dynamic_cast = true,
                                static_cast = true,
                                reinterpret_cast = true } }


class 'Smc.Cpp.Generator'
extends 'Smc.Generator'

has.suffix          = { '+', default = 'cpp' }
has.next_generator  = { '+', isa = 'Smc.Cpp.HeaderGenerator',
                        default = function () return require 'Smc.Cpp.HeaderGenerator' end }

function method:_build_template ()
    return CodeGen{
        TOP = [[
/*
 * ex: set ro:
 * DO NOT EDIT.
 * generated by smc (http://github.com/fperrad/lua-Smc)
 * from file : ${fsm.filename}
 */

${_preamble()}
${fsm._package; format=open_pkg}
${_base_state()}
${fsm.maps/_map()}
${fsm._package; format=close_pkg}

/*
 * Local variables:
 *  buffer-read-only: t
 * End:
 */
]],
        open_pkg = function (s) return s:gsub("([%w_]+):?:?","namespace %1\n{\n\n") end,
        close_pkg = function (s) return s:gsub("([%w_]+):?:?","\n}\n") end,
        _preamble = [[
${fsm.source}
${fsm.includeList/_include()}
#include "${generator.headerDirectory?_headerDirectory()!_srcDirectory()}${generator.targetfileBase}.h"

using namespace statemap;
${fsm.importList/_import()}

]],
            _include = [[
#include ${it}
]],
            _srcDirectory = "${generator.srcDirectory}",
            _headerDirectory = "${generator.headerDirectory}",
            _import = [[
using namespace ${it};
]],
        _base_state = [[
// Static class declarations.
${fsm.maps/_map_base_state()}

${generator.serialFlag?_base_state_serial()}
${fsm.transitions/_transition_base_state()}

void ${fsm.context}State::Default(${fsm.fsmClassname}& context)
{
    ${generator.debugLevel0?_base_state_debug()}
    ${generator.noExceptionFlag?_assert_transition_undefined()!_throw_transition_undefined_exception()}
}
]],
            _map_base_state = "${states/_state_base_state()}\n",
            _state_base_state = [[
${map.name}_${name} ${map.name}::${name}("${fullName}", ${map.index});
]],
            _base_state_serial = [[
${fsm.context}State* ${fsm.fsmClassname}::_States[] =
{
    ${fsm.maps/_map_base_state_serial(); separator=",\n"}
};
const int ${fsm.fsmClassname}::MIN_INDEX = 0;
const int ${fsm.fsmClassname}::MAX_INDEX = (sizeof(${fsm.fsmClassname}::_States) / sizeof(${fsm.context}State*)) - 1;

${fsm.context}State& ${fsm.fsmClassname}::valueOf(int stateId)
{
    ${generator.noExceptionFlag?_assert_base_state_serial()!_throw_base_state_serial_exception()}

    return static_cast<${fsm.context}State&>(*(_States[stateId]));
}
]],
                _map_base_state_serial = "${states/_state_base_state_serial(); separator=',\\n'}",
                    _state_base_state_serial = [[
&${map.name}::${name}
]],
                _assert_base_state_serial = [[
assert(stateId >= MIN_INDEX);
assert(stateId <= MAX_INDEX);
]],
                _throw_base_state_serial_exception = [[
if ((stateId < MIN_INDEX) || (stateId > MAX_INDEX))
{
    throw (
        IndexOutOfBoundsException(
            stateId, MIN_INDEX, MAX_INDEX));
}
]],
            _transition_base_state = "${isntDefault?_transition_base_state_if()}\n",
            _transition_base_state_if = [[

void ${fsm.context}State::${name}(${fsm.fsmClassname}& context${parameters/_parameter_proto()})
{
    Default(context);
}
]],
                _parameter_proto = ", ${_type} ${name}",
            _base_state_debug = [[
if (context.getDebugFlag())
{
    ${generator.noStreamFlag?_base_state_debug_no_stream()!_base_state_debug_stream()}
}
]],
                _base_state_debug_no_stream = [[
TRACE("TRANSITION   : Default()\n");
]],
                _base_state_debug_stream = [[
std::ostream& str = context.getDebugStream();

str << "TRANSITION   : Default()"
    << std::endl;
]],
            _assert_transition_undefined = [[
assert(false);
]],
            _throw_transition_undefined_exception = [[
throw (
    TransitionUndefinedException(
        context.getState().getName(),
        context.getTransition()));
]],
        _map = [[
${defaultState?_map_default_state()}
${states/_state()}
]],
            _map_default_state = "${defaultState.transitions/_transition()}",
        _state = [[
${entryActions?_state_entry()}
${exitActions?_state_exit()}
${transitions/_transition()}
]],
            _state_entry = [[

void ${map.name}_${name}::Entry(${fsm.fsmClassname}& context)
{
    ${fsm.context}& ctxt(context.getOwner());

    ${entryActions/_action()}
}
]],
            _state_exit = [[

void ${map.name}_${name}::Exit(${fsm.fsmClassname}& context)
{
    ${fsm.context}& ctxt(context.getOwner());

    ${exitActions/_action()}
}
]],
        _transition = [[

void ${state.map.name}_${state.name}::${name}(${fsm.fsmClassname}& context${parameters/_parameter_proto()})
{
    ${hasCtxtReference?_transition_ctxt()}
    ${generator.debugLevel0?_transition_debug()}
    ${guards/_guard()}
    ${needFinalElse?_transition_else()}
}
]],
            _transition_ctxt = [[
${fsm.context}& ctxt(context.getOwner());
]],
            _transition_debug = [[

if (context.getDebugFlag())
{
    ${generator.noStreamFlag?_transition_debug_no_stream()!_transition_debug_stream()}
}

]],
                _transition_debug_no_stream = [[
TRACE("LEAVING STATE   : ${state.fullName}\n");
]],
                _transition_debug_stream = [[
std::ostream& str = context.getDebugStream();

str << "LEAVING STATE   : ${state.fullName}"
    << std::endl;
]],
            _transition_else = [[
else
{
    ${state.isDefault?_super_default()!_super()}::${name}(context${parameters/_parameter_call()});
}
]],
                _super_default = "${fsm.context}State",
                _super = "${map.name}_DefaultState",
                _parameter_call = ", ${name}",
        _guard = "${isConditional?_guard_conditional()!_guard_unconditional()}",
            _guard_conditional = "${ifCondition?_guard_if()!_guard_no_if()}",
            _guard_no_if = "${elseifCondition?_guard_elseif()!_guard_else()}",
            _guard_unconditional = [[
${_guard_core()}
]],
            _guard_if = [[
if (${condition})
{
    ${_guard_core()}
}
]],
            _guard_elseif = [[

else if (${condition})
{
    ${_guard_core()}
}
]],
            _guard_else = [[

else
{
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
${fsm.context}State& endState = context.getState();
]],
                _guard_exit = [[
${generator.debugLevel1?_guard_debug_before_exit()}
context.getState().Exit(context);
${generator.debugLevel1?_guard_debug_after_exit()}
]],
                    _guard_debug_before_exit = [[
if (context.getDebugFlag())
{
    ${generator.noStreamFlag?_guard_debug_before_exit_no_stream()!_guard_debug_before_exit_stream()}
}
]],
                        _guard_debug_before_exit_no_stream = [[
TRACE("BEFORE EXIT     : ${transition.state.fullName}.Exit()\n");
]],
                        _guard_debug_before_exit_stream = [[
std::ostream& str = context.getDebugStream();

str << "BEFORE EXIT     : ${transition.state.fullName}.Exit()"
    << std::endl;
]],
                    _guard_debug_after_exit = [[
if (context.getDebugFlag())
{
    ${generator.noStreamFlag?_guard_debug_after_exit_no_stream()!_guard_debug_after_exit_stream()}
}
]],
                        _guard_debug_after_exit_no_stream = [[
TRACE("AFTER EXIT      : ${transition.state.fullName}.Exit()\n");
]],
                        _guard_debug_after_exit_stream = [[
std::ostream& str = context.getDebugStream();

str << "AFTER EXIT      : ${transition.state.fullName}.Exit()"
    << std::endl;
]],
                _guard_debug_enter = [[
if (context.getDebugFlag())
{
    ${generator.noStreamFlag?_guard_debug_enter_no_stream()!_guard_debug_enter_stream()}
}
]],
                    _guard_debug_enter_no_stream = [[
TRACE("ENTER TRANSITION: ${transition.state.fullName}.${transition.name}(${transition.parameters/_guard_debug_param(); separator=', '})\n");
]],
                        _guard_debug_param = "${name}",
                    _guard_debug_enter_stream = [[
std::ostream& str = context.getDebugStream();

str << "ENTER TRANSITION: ${transition.state.fullName}.${transition.name}(${transition.parameters/_guard_debug_param(); separator=', '})"
    << std::endl;
]],
                _guard_no_action = [[
${isConditional?_guard_no_action_if()}
${_guard_final()}
]],
                    _guard_no_action_if = [[
// No actions.
]],
                _guard_actions = [[
context.clearState();
${generator.catchFlag?_guard_actions_protected()!_guard_actions_not_protected()}
]],
                    _guard_actions_protected = [[
try
{
    ${actions/_action()}
    ${generator.debugLevel0?_guard_debug_exit()}
    ${doesSet?_guard_set()}
}
catch (...)
{
    ${doesSet?_guard_set()}
    throw;
}
${_guard_final()}
]],
                        _guard_actions_not_protected = [[
${actions/_action()}
${generator.debugLevel0?_guard_debug_exit()}
${doesSet?_guard_set()}
${_guard_final()}
]],
                            _guard_final = [[
${doesPush?_guard_push()}
${doesPop?_guard_pop()}
${doesEntry?_guard_entry()}
]],
                _guard_debug_exit = [[
if (context.getDebugFlag())
{
    ${generator.noStreamFlag?_guard_debug_exit_no_stream()!_guard_debug_exit_stream()}
}
]],
                    _guard_debug_exit_no_stream = [[
TRACE("EXIT TRANSITION : ${transition.state.fullName}.${transition.name}(${transition.parameters/_guard_debug_param(); separator=', '})\n");
]],
                    _guard_debug_exit_stream = [[
std::ostream& str = context.getDebugStream();

str << "EXIT TRANSITION : ${transition.state.fullName}.${transition.name}(${transition.parameters/_guard_debug_param(); separator=', '})"
    << std::endl;
]],
                _guard_set = [[
context.setState(${needVarEndState?_end_state_var()!_end_state_no_var()});
]],
                    _end_state_var = "endState",
                    _end_state_no_var = "${endStateName}",
                _guard_push = [[
${doesPushSet?_guard_set()}
${doesPushEntry?_guard_entry()}
context.pushState(${pushStateName});
]],
                _guard_pop = [[
context.popState();
]],
                _guard_entry = [[
${generator.debugLevel1?_guard_debug_before_entry()}
context.getState().Entry(context);
${generator.debugLevel1?_guard_debug_after_entry()}
]],
                    _guard_debug_before_entry = [[
if (context.getDebugFlag())
{
    ${generator.noStreamFlag?_guard_debug_before_entry_no_stream()!_guard_debug_before_entry_stream()}
}
]],
                        _guard_debug_before_entry_no_stream = [[
TRACE("BEFORE ENTRY    : ${transition.state.fullName}.Entry()\n");
]],
                        _guard_debug_before_entry_stream = [[
std::ostream& str = context.getDebugStream();

str << "BEFORE ENTRY    : ${transition.state.fullName}.Entry()"
    << std::endl;
]],
                    _guard_debug_after_entry = [[
if (context.getDebugFlag())
{
    ${generator.noStreamFlag?_guard_debug_after_entry_no_stream()!_guard_debug_after_entry_stream()}
}
]],
                        _guard_debug_after_entry_no_stream = [[
TRACE("AFTER ENTRY     : ${transition.state.fullName}.Entry()\n");
]],
                        _guard_debug_after_entry_stream = [[
std::ostream& str = context.getDebugStream();

str << "AFTER ENTRY     : ${transition.state.fullName}.Entry()"
    << std::endl;
]],
                _guard_end_pop = [[
context.${endStateName}(${popArgs});
]],
        _action = "${isEmptyStateStack?_action_ess()!_action_no_ess()}",
            _action_ess = [[
context.emptyStateStack();
]],
            _action_no_ess = [[
ctxt.${name}(${arguments; separator=', '});
]],
    }
end


class 'Smc.Cpp.HeaderGenerator'
extends 'Smc.Generator'

has.suffix          = { '+', default = 'h' }

function method:_build_template ()
    return CodeGen{
        TOP = [[
/*
 * ex: set ro:
 * DO NOT EDIT.
 * generated by smc (http://github.com/fperrad/lua-Smc)
 * from file : ${fsm.filename}
 */

#ifndef ${generator.targetfileBase; format=guarded}_H
#define ${generator.targetfileBase; format=guarded}_H

${_preample()}
${fsm._package; format=open_pkg}
${_forward_decl()}
${_base_state()}
${fsm.maps/_map()}
${_context()}
${fsm._package; format=close_pkg}

#endif // ${generator.targetfileBase; format=guarded}_H

/*
 * Local variables:
 *  buffer-read-only: t
 * End:
 */
]],
        guarded = function (s)
            s = s:gsub("\\", "_")
            s = s:gsub("/", "_")
            return s:upper()
        end,
        open_pkg = function (s) return s:gsub("([%w_]+):?:?","\nnamespace %1\n{\n") end,
        close_pkg = function (s) return s:gsub("([%w_]+):?:?","\n}\n") end,
        _preample = [[
${generator.noStreamFlag?_empty()!_def_stream()}
${generator.noExceptionFlag?_def_no_exception()}
#include <statemap.h>
]],
            _empty = '',
            _def_stream = [[
#define SMC_USES_IOSTREAMS

]],
            _def_no_exception = [[
#define SMC_NO_EXCEPTIONS

]],
        _forward_decl = [[

// Forward declarations.
${fsm.maps/_map_forward_decl()}
class ${fsm.context}State;
class ${fsm.fsmClassname};
class ${fsm.context};
${fsm.declareList/_declare()}
]],
            _map_forward_decl = [[
class ${name};
${states/_state_forward_decl()}
class ${name}_DefaultState;
]],
                _state_forward_decl = [[
class ${map.name}_${name};
]],
            _declare = "${it}\n",
        _base_state = [[

class ${fsm.context}State :
    public statemap::State
{
public:

    ${fsm.context}State(const char *name, int stateId)
    : statemap::State(name, stateId)
    {};

    virtual void Entry(${fsm.fsmClassname}&) {};
    virtual void Exit(${fsm.fsmClassname}&) {};

    ${fsm.transitions/_transition_base_state()}

protected:

    virtual void Default(${fsm.fsmClassname}& context);
};
]],
            _transition_base_state = "${isntDefault?_transition_base_state_if()}\n",
            _transition_base_state_if = [[
virtual void ${name}(${fsm.fsmClassname}& context${parameters/_parameter_proto()});
]],
                _parameter_proto = ", ${_type} ${name}",
        _map = [[

class ${name}
{
public:

    ${states/_state_decl()}
};

class ${name}_DefaultState :
    public ${fsm.context}State
{
public:

    ${name}_DefaultState(const char *name, int stateId)
    : ${fsm.context}State(name, stateId)
    {};

    ${defaultState?_map_default_state()}
};

${states/_state()}
]],
            _state_decl = [[
static ${map.name}_${name} ${name};
]],
            _map_default_state = "${defaultState.transitions/_transition_default_state()}",
                _transition_default_state = [[
virtual void ${name}(${fsm.fsmClassname}& context${parameters/_parameter_proto()});
]],
        _state = [[

class ${map.name}_${name} :
    public ${map.name}_DefaultState
{
public:

    ${map.name}_${name}(const char *name, int stateId)
    : ${map.name}_DefaultState(name, stateId)
    {};

    ${entryActions?_state_entry()}
    ${exitActions?_state_exit()}
    ${transitions/_transition()}
};
]],
            _state_entry = [[
void Entry(${fsm.fsmClassname}&);
]],
            _state_exit = [[
void Exit(${fsm.fsmClassname}&);
]],
        _transition = [[
void ${name}(${fsm.fsmClassname}& context${parameters/_parameter_proto()});
]],
        _context = [[

class ${fsm.fsmClassname} :
    public statemap::FSMContext
{
public:

    ${fsm.fsmClassname}(${fsm.context}& owner)
    : FSMContext(${fsm.startState}),
      _owner(owner)
    {};

    ${fsm.fsmClassname}(${fsm.context}& owner, const statemap::State& state)
    : FSMContext(state),
      _owner(owner)
    {};

    virtual void enterStartState()
    {
        getState().Entry(*this);
    };

    ${fsm.context}& getOwner() const
    {
        return _owner;
    };

    ${fsm.context}State& getState() const
    {
        ${generator.noExceptionFlag?_assert_state_undefined()!_throw_state_undefined_exception()}

        return ${generator.castType}<${fsm.context}State&>(*_state);
    };
    ${fsm.transitions/_transition_context()}
    ${generator.serialFlag?_context_serial()}

 private:

    ${fsm.context}& _owner;
    ${generator.serialFlag?_context_private_serial()}
};
]],
            _assert_state_undefined = [[
assert(_state != NULL);
]],
            _throw_state_undefined_exception = [[
if (_state == NULL)
{
    throw statemap::StateUndefinedException();
}
]],
            _transition_context = "${isntDefault?_transition_context_if()}\n",
            _transition_context_if = [[

void ${name}(${parameters/_parameter_proto_context(); separator=", "})
{
    ${generator.debugLevel0?_transition_debug_set()}
    getState().${name}(*this${parameters/_parameter_call_context()});
    ${generator.debugLevel0?_transition_debug_unset()}
};
]],
                _parameter_proto_context = "${_type} ${name}",
                _parameter_call_context = ", ${name}",
                _transition_debug_set = [[
setTransition("${name}");
]],
                _transition_debug_unset = [[
setTransition(NULL);
]],
            _context_serial = [[

static ${fsm.context}State& valueOf(int stateId);
]],
            _context_private_serial = [[
const static int MIN_INDEX;
const static int MAX_INDEX;
static ${fsm.context}State* _States[];
]],
    }
end
