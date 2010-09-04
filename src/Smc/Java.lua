
require 'Coat'

singleton 'Smc.Java'
extends 'Smc.Language'

has.id              = { '+', default = 'JAVA' }
has.name            = { '+', default = 'Java' }
has.option          = { '+', default = '-java' }
has.suffix          = { '+', default = 'Context' }
has.generator       = { '+', isa = 'Smc.Java.Generator',
                        default = function () return require 'Smc.Java.Generator' end }
has.accessFlag      = { '+', default = true }
has.genericFlag     = { '+', default = true }
has.reflectFlag     = { '+', default = true }
has.serialFlag      = { '+', default = true }
has.syncFlag        = { '+', default = true }
has.accessLevels    = { '+', default = {
                                public = 'public',
                                protected = 'protected',
                                package = '/* package */',
                                private = 'private' } }


class 'Smc.Java.Generator'
extends 'Smc.Generator'

has.suffix          = { '+', default = 'java' }

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
${_context()}

/*
 * Local variables:
 *  buffer-read-only: t
 * End:
 */
]],
        _preamble = [[
${fsm.source}
${fsm._package?__package()}
${fsm.importList:_import()}
${generator.debugLevel0?_import_debug()}
${generator.reflectFlag?_import_reflect()}
]],
            __package = [[
package ${fsm._package};

]],
            _import = [[
import ${it};
]],
            _import_debug = [[
import java.io.PrintStream;
]],
            _import_reflect = [[
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;
]],
        _context = [[

${generator.accessLevel} class ${fsm.fsmClassname}
    extends statemap.FSMContext
    ${generator.serialFlag?_serializable()}
{
//---------------------------------------------------------------
// Member methods.
//

    ${generator.accessLevel} ${fsm.fsmClassname}(${fsm.context} owner)
    {
        super (${fsm.startState; format=scoped});
        _owner = owner;
        ${generator.reflectFlag?_context_constructor_reflect()}
    }

    ${generator.accessLevel} ${fsm.fsmClassname}(${fsm.context} owner, ${fsm.context}State initState)
    {
        super (initState);
        _owner = owner;
        ${generator.reflectFlag?_context_constructor_reflect()}
    }

    public ${generator.syncFlag?_synchronized()}void enterStartState()
    {
        getState().Entry(this);
        return;
    }
    ${fsm.transitions:_transition_context()}
    ${generator.serialFlag?_context_serial1()}

    public ${fsm.context}State getState()
        throws statemap.StateUndefinedException
    {
        if (_state == null)
        {
            throw(
                new statemap.StateUndefinedException());
        }

        return ((${fsm.context}State) _state);
    }

    protected ${fsm.context} getOwner()
    {
        return (_owner);
    }

    public void setOwner(${fsm.context} owner)
    {
        if (owner == null)
        {
            throw (
                new NullPointerException(
                    "null owner"));
        }
        else
        {
            _owner = owner;
        }

        return;
    }
    ${generator.reflectFlag?_context_reflect()}
    ${generator.serialFlag?_context_serial2()}

//---------------------------------------------------------------
// Member data.
//

    transient private ${fsm.context} _owner;
    ${generator.reflectFlag?_context_data_transitions()}
    ${generator.reflectFlag?_context_data_states()!_context_data_states_or()}
    ${_base_state()}
    ${fsm.maps:_map()}
}
]],
            scoped = function (str) return str:gsub('::','.') end,
            _serializable = [[
implements java.io.Serializable
]],
            _synchronized = "synchronized ",
            _generic_string = "<String>",
            _generic_str_int = "<String, Integer>",
            _context_constructor_reflect = [[
_transitions = new TreeSet${generator.genericFlag?_generic_string()}();

${fsm.transitions:_transition_context_reflect()}
]],
                _transition_context_reflect = [[
_transitions.add("${name}");
]],
            _transition_context = "${isntDefault?_transition_context_if()}\n",
            _transition_context_if = [[

public ${generator.syncFlag?_synchronized()}void ${name}(${parameters:_parameter_proto_context(); separator=", "})
{
    _transition = "${name}";
    getState().${name}(this${parameters:_parameter_call()});
    _transition = "";
    return;
}
]],
                _parameter_proto_context = "${_type} ${name}",
                _parameter_call = ", ${name}",
            _context_serial1 = [[

public ${fsm.context}State valueOf(int stateId)
    throws ArrayIndexOutOfBoundsException
{
    return (_States[stateId]);
}
]],
            _context_reflect = [[

public ${fsm.context}State[] getStates()
{
    return (_States);
}

public Set${generator.genericFlag?_generic_string()} getTransitions()
{
    return (_transitions);
}
]],
            _context_serial2 = [[

private void writeObject(java.io.ObjectOutputStream ostream)
    throws java.io.IOException
{
    int size =
        _stateStack == null ? 0 : _stateStack.size();
    int i;

    ostream.writeInt(size);

    for (i = 0; i < size; ++i)
    {
        ostream.writeInt(
            ((${fsm.context}State) _stateStack.get(i)).getId());
    }

    ostream.writeInt(_state.getId());

    return;
}

private void readObject(java.io.ObjectInputStream istream)
    throws java.io.IOException
{
    int size;

    size = istream.readInt();

    if (size == 0)
    {
        _stateStack = null;
    }
    else
    {
        int i;

        _stateStack =
            new java.util.Stack<statemap.State>();

        for (i = 0; i < size; ++i)
        {
            _stateStack.add(i, _States[istream.readInt()]);
        }
    }

    _state = _States[istream.readInt()];

    return;
}
]],
            _context_data_transitions = [[
final Set${generator.genericFlag?_generic_string()} _transitions;
]],
            _context_data_states = [[
transient private static ${fsm.context}State[] _States =
{
    ${fsm.maps:_map_context_reflect(); separator=",\n"}
};
]],
            _context_data_states_or = "${generator.serialFlag?_context_data_states()}",
            _map_context_reflect = '${states:_state_context_reflect(); separator=",\\n"}',
                _state_context_reflect = [[
${map.name}.${className}
]],
        _base_state = [[

${generator.accessLevel} static abstract class ${fsm.context}State
    extends statemap.State
{
//-----------------------------------------------------------
// Member methods.
//
    ${generator.reflectFlag?_base_state_reflect()}

    protected ${fsm.context}State(String name, int id)
    {
        super (name, id);
    }

    protected void Entry(${fsm.fsmClassname} context) {}
    protected void Exit(${fsm.fsmClassname} context) {}
    ${fsm.transitions:_transition_base_state()}

    protected void Default(${fsm.fsmClassname} context)
    {
        ${generator.debugLevel0?_base_state_debug()}
        throw (
            new statemap.TransitionUndefinedException(
                "State: " +
                context.getState().getName() +
                ", Transition: " +
                context.getTransition()));
    }

//-----------------------------------------------------------
// Member data.
//
}
]],
            _base_state_reflect = [[

public abstract Map${generator.genericFlag?_generic_str_int()} getTransitions();
]],
            _transition_base_state = "${isntDefault?_transition_base_state_if()}\n",
            _transition_base_state_if = [[

protected void ${name}(${fsm.fsmClassname} context${parameters:_parameter_proto()})
{
    Default(context);
}
]],
                _parameter_proto = ", ${_type} ${name}",
            _base_state_debug = [[
if (context.getDebugFlag() == true)
{
    PrintStream str =
    context.getDebugStream();

    str.println(
        "TRANSITION   : Default");
}

]],
        _map = [[

/* package */ static abstract class ${name}
{
//-----------------------------------------------------------
// Member methods.
//

//-----------------------------------------------------------
// Member data.
//

    //-------------------------------------------------------
    // Constants.
    //
    ${states:_state_init()}
    private static final ${name}_Default Default =
        new ${name}_Default("$name}.Default", -1);

}

protected static class ${name}_Default
    extends ${fsm.context}State
{
//-----------------------------------------------------------
// Member methods.
//
    ${generator.reflectFlag?_default_state_reflect()}

    protected ${name}_Default(String name, int id)
    {
        super (name, id);
    }
    ${defaultState?_map_default_state()}

//-----------------------------------------------------------
// Member data.
//
    ${generator.reflectFlag?_default_state_reflect_init()}
}

${states:_state()}
]],
            _state_init = [[
public static final ${map.name}_${className} ${instanceName} =
    new ${map.name}_${className}("${map.name}.${className}", ${map.nextStateId});
]],
            _map_default_state = "${defaultState.transitions:_transition()}",
            _default_state_reflect = [[

public Map${generator.genericFlag?_generic_str_int()} getTransitions()
{
    return (_transitions);
}
]],
            _default_state_reflect_init = [[

//---------------------------------------------------
// Statics.
//
private static Map${generator.genericFlag?_generic_str_int()} _transitions;

static
{
    _transitions = new HashMap${generator.genericFlag?_generic_str_int()}();
    ${reflect:_reflect()}
};
]],
        _state = [[

private static final class ${map.name}_${className}
    extends ${map.name}_Default
{
//-------------------------------------------------------
// Member methods.
//
    ${generator.reflectFlag?_state_reflect()}

    private ${map.name}_${className}(String name, int id)
    {
        super (name, id);
    }
    ${entryActions?_state_entry()}
    ${exitActions?_state_exit()}
    ${transitions:_transition()}

//-------------------------------------------------------
// Member data.
//
    ${generator.reflectFlag?_state_reflect_init()}
}
]],
            _state_reflect = [[
private static Map${generator.genericFlag?_generic_str_int()} _transitions;

public Map${generator.genericFlag?_generic_str_int()} getTransitions()
{
    return (_transitions);
}
]],
            _state_entry = [[

protected void Entry(${fsm.fsmClassname} context)
{
    ${fsm.context} ctxt = context.getOwner();

    ${entryActions:_action()}
    return;
}
]],
            _state_exit = [[

protected void Exit(${fsm.fsmClassname} context)
{
    ${fsm.context} ctxt = context.getOwner();

    ${exitActions:_action()}
    return;
}
]],
            _state_reflect_init = [[

static
{
    _transitions = new HashMap${generator.genericFlag?_generic_str_int()}();
    ${reflect:_reflect()}
}
]],
                _reflect = [[
_transitions.put("${name}", statemap.State.${def; format=trans_def});
]],
                trans_def = function (n)
                    if n == 2 then
                        return "TRANSITION_DEFINED_DEFAULT"
                    elseif n == 1 then
                        return "TRANSITION_DEFINED_LOCALLY"
                    else
                        return "TRANSITION_UNDEFINED"
                    end
                end,
        _transition = [[

protected void ${name}(${fsm.fsmClassname} context${parameters:_parameter_proto()})
{
    ${hasCtxtReference?_transition_ctxt()}
    ${generator.debugLevel0?_transition_debug()}
    ${guards:_guard()}
    ${needFinalElse?_transition_else()}

    return;
}
]],
            _transition_ctxt = [[
${fsm.context} ctxt = context.getOwner();

]],
            _transition_debug = [[
if (context.getDebugFlag() == true)
{
    PrintStream str = context.getDebugStream();

    str.println("LEAVING STATE   : ${state.map.name}.${state.className}");
}

]],
            _transition_else = [[
else
{
    super.${name}(context${parameters:_parameter_call()});
}
]],
        _guard = "${hasCondition?_guard_conditional()!_guard_unconditional()}",
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
${fsm.context}State ${varEndState} = context.getState();
]],
                    _guard_exit = [[
${generator.debugLevel1?_guard_debug_before_exit()}
(context.getState()).Exit(context);
${generator.debugLevel1?_guard_debug_after_exit()}
]],
                        _guard_debug_before_exit = [[
if (context.getDebugFlag() == true)
{
    PrintStream str = context.getDebugStream();

    str.println("BEFORE EXIT     : ${transition.state.fullName}.Exit(fsm)");
}
]],
                        _guard_debug_after_exit = [[
if (context.getDebugFlag() == true)
{
    PrintStream str = context.getDebugStream();

    str.println("AFTER EXIT      : ${transition.state.fullName}.Exit(fsm)");
}
]],
                    _guard_debug_enter = [[
if (context.getDebugFlag() == true)
{
    PrintStream str = context.getDebugStream();

    str.println("ENTER TRANSITION: ${transition.state.fullName}.${transition.name}(${transition.parameters:_parameter_proto_context(); separator=', '})");
}
]],
                    _guard_no_action = [[
${hasCondition?_guard_no_action_if()}
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
    ${actions:_action()}
}
finally
{
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
if (context.getDebugFlag() == true)
{
    PrintStream str = context.getDebugStream();

    str.println("EXIT TRANSITION : ${transition.state.fullName}.${transition.name}(${transition.parameters:_parameter_proto_context(); separator=', '})");
}
]],
                                _guard_set = [[
context.setState(${varEndState});
]],
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
(context.getState()).Entry(context);
${generator.debugLevel1?_guard_debug_after_entry()}
]],
                                    _guard_debug_before_entry = [[
if (context.getDebugFlag() == true)
{
    PrintStream str = context.getDebugStream();

    str.println("BEFORE ENTRY    : ${transition.state.fullName}.Exit(fsm)");
}
]],
                                    _guard_debug_after_entry = [[
if (context.getDebugFlag() == true)
{
    PrintStream str = context.getDebugStream();

    str.println("AFTER ENTRY     : ${transition.state.fullName}.Exit(fsm)");
}
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
