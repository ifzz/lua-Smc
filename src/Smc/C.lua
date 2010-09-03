
require 'Coat'

singleton 'Smc.C'
extends 'Smc.Language'

has.id              = { '+', default = 'C' }
has.name            = { '+', default = 'C' }
has.option          = { '+', default = '-c' }
has.suffix          = { '+', default = '_sm' }
has.generator       = { '+', isa = 'Smc.C.Generator',
                        default = function () return require 'Smc.C.Generator' end }
has.headerFlag      = { '+', default = true }


class 'Smc.C.Generator'
extends 'Smc.Generator'

has.suffix          = { '+', default = 'c' }
has.scopeSep        = { '+', default = '_' }
has.next_generator  = { '+', isa = 'Smc.C.HeaderGenerator',
                        default = function () return require 'Smc.C.HeaderGenerator' end }
has.context         = { is = 'ro', isa = 'string' }

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
${_base_state()}
${fsm.maps:_map()}
${_context()}

/*
 * Local variables:
 *  buffer-read-only: t
 * End:
 */
]],
        _preamble = [[
${fsm.source}
#include <assert.h>
${fsm.includeList:_include()}
#include "${generator.headerDirectory?_headerDirectory()!_srcDirectory()}${generator.targetfileBase}.h"

#define getOwner(fsm) \
    (fsm)->_owner
]],
            _include = [[
#include ${it}
]],
            _srcDirectory = "${generator.srcDirectory}",
            _headerDirectory = "${generator.headerDirectory}",
        _base_state = [[

#define POPULATE_STATE(state) \
    ${fsm.hasEntryActions?_populate_entry()}
    ${fsm.hasExitActions?_populate_exit()}
    ${fsm.transitions:_populate_transition()}
    state##_Default

${fsm.hasEntryActions?_def_entry()!_def_no_entry()}

${fsm.hasExitActions?_def_exit()!_def_no_exit()}
${fsm.transitions:_transition_base_state()}

static void ${fsm.context}State_Default(struct ${fsm.fsmClassname}* fsm)
{
    ${generator.debugLevel0?_base_state_debug()}
    State_Default(fsm);
}
]],
            _populate_entry = [[
state##_Entry, \
]],
            _populate_exit = [[
state##_Exit, \
]],
            _populate_transition = "${isntDefault?_populate_transition_if()}\n",
            _populate_transition_if = [[
state##_${name}, \
]],
            _def_entry = [[
#define ENTRY_STATE(state) \
    if ((state)->Entry != NULL) { \
        (state)->Entry(fsm); \
    }
]],
            _def_no_entry = [[
#define ENTRY_STATE(state)
]],
            _def_exit = [[
#define EXIT_STATE(state) \
    if ((state)->Exit != NULL) { \
        (state)->Exit(fsm); \
    }
]],
            _def_no_exit = [[
#define EXIT_STATE(state)
]],
            _transition_base_state = "${isntDefault?_transition_base_state_if()}\n",
            _transition_base_state_if = [[

static void ${fsm.context}State_${name}(struct ${fsm.fsmClassname}* fsm${parameters:_parameter_proto()})
{
    getState(fsm)->Default(fsm);
}
]],
                _parameter_proto = ", ${_type} ${name}",
            _base_state_debug = [[
if (getDebugFlag(fsm) != 0) {
    TRACE("TRANSITION   : %s.%s\n\r", getName(getState(fsm)), getTransition(fsm));
}
]],
        _map = [[
${defaultState?_map_default_state()}
${states:_state()}
]],
            _map_default_state = [[

${fsm.transitions:_transition_default_def()}
#define ${name}_DefaultState_Default ${fsm.context}State_Default
${defaultState.transitions:_transition()}
]],
                _transition_default_def = "${isntDefault?_transition_default_def_if()}\n",
                _transition_default_def_if = [[
#define ${mapName}_DefaultState_${name} ${fsm.context}State_${name}
]],
        _state = [[

${fsm.transitions:_transition_def()}
#define ${map.name}_${instanceName}_Default ${map.defaultState?_default_state_name()!_base_state_name()}_Default
#define ${map.name}_${instanceName}_Entry NULL
#define ${map.name}_${instanceName}_Exit NULL
${entryActions?_state_entry()}
${exitActions?_state_exit()}
${transitions:_transition()}

const struct ${fsm.context}State ${map.name}_${instanceName} = { POPULATE_STATE(${map.name}_${instanceName}), "${map.name}_${instanceName}", ${map.nextStateId} };
]],
            _transition_def = "${isntDefault?_transition_def_if()}\n",
            _transition_def_if = [[
#define ${map.name}_${instanceName}_${name} ${map.defaultState?_default_state_name()!_base_state_name()}_${name}
]],
                _default_state_name = "${map.name}_DefaultState",
                _base_state_name = "${fsm.context}State",
            _state_entry = [[

#undef ${map.name}_${instanceName}_Entry
void ${map.name}_${instanceName}_Entry(struct ${fsm.fsmClassname}* fsm)
{
    struct ${fsm.context}* ctxt = getOwner(fsm);

    ${entryActions:_action()}
}
]],
            _state_exit = [[

#undef ${map.name}_${instanceName}_Exit
void ${map.name}_${instanceName}_Exit(struct ${fsm.fsmClassname}* fsm)
{
    struct ${fsm.context}* ctxt = getOwner(fsm);

    ${exitActions:_action()}
}
]],
        _transition = [[

#undef ${state.map.name}_${state.instanceName}_${name}
static void ${state.map.name}_${state.instanceName}_${name}(struct ${fsm.fsmClassname}* fsm${parameters:_parameter_proto()})
{
    ${hasCtxtReference?_transition_ctxt()}
    ${generator.debugLevel0?_transition_debug()}
    ${guards:_guard()}
    ${needFinalElse?_transition_else()}
}
]],
            _transition_ctxt = [[
struct ${fsm.context}* ctxt = getOwner(fsm);
]],
            _transition_debug = [[
if (getDebugFlag(fsm) != 0) {
    TRACE("LEAVING STATE   : ${state.map.name}_${state.className}\n\r");
}
]],
            _transition_else = [[
else {
    ${map.name}_DefaultState_${name}(fsm${parameters:_parameter_call()});
}
]],
                _parameter_call = ", ${name}",
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
${generator.debugLevel0?_guard_debug_exit()}
${doesSet?_guard_set()}
${doesPush?_guard_push()}
${doesPop?_guard_pop()}
${doesEntry?_guard_entry()}
${doesEndPop?_guard_end_pop()}
]],
                _guard_end_state = [[
const struct ${fsm.context}State* ${varEndState} = getState(fsm);

]],
                _guard_exit = [[
${generator.debugLevel1?_guard_debug_before_exit()}
EXIT_STATE(getState(fsm));
${generator.debugLevel1?_guard_debug_after_exit()}
]],
                    _guard_debug_before_exit = [[
if (getDebugFlag(fsm) != 0) {
    TRACE("BEFORE EXIT     : EXIT_STATE(${transition.state.fullName})\n\r");
}
]],
                    _guard_debug_after_exit = [[
if (getDebugFlag(fsm) != 0) {
    TRACE("AFTER EXIT      : EXIT_STATE(${transition.state.fullName})\n\r");
}
]],
                _guard_debug_enter = [[
if (getDebugFlag(fsm) != 0) {
    TRACE("ENTER TRANSITION: ${transition.state.fullName}_${transition.name}(fsm${transition.parameters:_parameter_context_call(); separator=', '})\n\r");
}
]],
                _guard_no_action = "${hasCondition?_guard_no_action_if()}",
                    _guard_no_action_if = [[
/* No actions. */
]],
                _guard_actions = [[
clearState(fsm);
${actions:_action()}
]],
                _guard_debug_exit = [[
if (getDebugFlag(fsm) != 0) {
    TRACE("EXIT TRANSITION : ${transition.state.fullName}_${transition.name}(fsm${transition.parameters:_parameter_context_call(); separator=', '})\n\r");
}
]],
                _guard_set = [[
setState(fsm, ${varEndState; format=scoped});
]],
                scoped = function (s)
                    if s == 'endState' then
                        return s
                    end
                    s = s:gsub("%.", "_")
                    s = s:gsub("::", "_")
                    return "&" .. s
                end,
                _guard_push = [[
${doesPushSet?_guard_set()}
${doesPushEntry?_guard_entry()}
pushState(fsm, ${pushStateName; format=scoped});
]],
                _guard_pop = [[
popState(fsm);
]],
                _guard_entry = [[
${generator.debugLevel1?_guard_debug_before_entry()}
ENTRY_STATE(getState(fsm));
${generator.debugLevel1?_guard_debug_after_entry()}
]],
                    _guard_debug_before_entry = [[
if (getDebugFlag(fsm) != 0) {
    TRACE("BEFORE ENTRY    : ENTRY_STATE(${transition.state.fullName})\n\r");
}
]],
                    _guard_debug_after_entry = [[
if (getDebugFlag(fsm) != 0) {
    TRACE("AFTER ENTRY     : ENTRY_STATE(${transition.state.fullName})\n\r");
}
]],
                _guard_end_pop = [[
${fsm.fsmClassname}_${endStateName}(fsm${popArgs; format=with_arg});
]],
                with_arg = function (s)
                    if s == '' then
                        return s
                    else
                        return ", " .. s
                    end
                end,
        _action = "${isEmptyStateStack?_action_ess()!_action_no_ess()}",
            _action_ess = [[
emptyStateStack(fsm);
]],
            _action_no_ess = [[
${fsm.context}_${name}(ctxt${arguments?_action_arg()});
]],
                _action_arg = ", ${arguments; separator=', '}",
        _context = [[

void ${fsm.fsmClassname}_Init(struct ${fsm.fsmClassname}* fsm, struct ${fsm.context}* owner)
{
    FSM_INIT(fsm, ${fsm.startState; format=scoped});
    fsm->_owner = owner;
}
${fsm.hasEntryActions?_enter_start()}
${fsm.transitions:_transition_context()}
]],
            _enter_start = [[

void ${fsm.fsmClassname}_EnterStartState(struct ${fsm.fsmClassname}* fsm)
{
    ENTRY_STATE(getState(fsm));
}
]],
            _transition_context = "${isntDefault?_transition_context_if()}\n",
            _transition_context_if = [[

void ${fsm.fsmClassname}_${name}(struct ${fsm.fsmClassname}* fsm${parameters:_parameter_context_proto()})
{
    const struct ${fsm.context}State* state = getState(fsm);

    assert(state != NULL);
    setTransition(fsm, "${name}");
    state->${name}(fsm${parameters:_parameter_context_call()});
    setTransition(fsm, NULL);
}
]],
                _parameter_context_proto = ", ${_type} ${name}",
                _parameter_context_call = ", ${name}",
    }
end


class 'Smc.C.HeaderGenerator'
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

#ifndef _H_${generator.targetfileBase; format=guarded}
#define _H_${generator.targetfileBase; format=guarded}

${_preample()}
${_base_state()}
${fsm.maps:_map()}
${_context()}

#endif

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
        _preample = [[
#include <statemap.h>

${fsm.declareList:_declare()}
]],
            _declare = "${it; format=declare}\n",
            declare = function (s)
                if s:match ";$" then
                    return s
                else
                    return s .. ";"
                end
            end,
        _base_state = [[
struct ${fsm.context};
struct ${fsm.fsmClassname};

struct ${fsm.context}State
{
    ${fsm.hasEntryActions?_member_entry()}
    ${fsm.hasExitActions?_member_exit()}
    ${fsm.transitions:_transition_member()}
    void(*Default)(struct ${fsm.fsmClassname}*);

    STATE_MEMBERS
};

]],
            _member_entry = [[
void(*Entry)(struct ${fsm.fsmClassname}*);
]],
            _member_exit = [[
void(*Exit)(struct ${fsm.fsmClassname}*);
]],
            _transition_member = "${isntDefault?_transition_member_if()}\n",
            _transition_member_if = [[
void(*${name})(struct ${fsm.fsmClassname}*${parameters:_parameter_proto()});
]],
                _parameter_proto = ", ${_type}",
        _map = "${states:_state()}\n",
        _state = [[
extern const struct ${fsm.context}State ${map.name}_${instanceName};
]],
        _context = [[

struct ${fsm.fsmClassname}
{
    FSM_MEMBERS(${fsm.context})
    struct ${fsm.context} *_owner;
};

extern void ${fsm.fsmClassname}_Init(struct ${fsm.fsmClassname}*, struct ${fsm.context}*);
${fsm.hasEntryActions?_enter_start()}
${fsm.transitions:_transition_context()}
]],
            _enter_start = [[
extern void ${fsm.fsmClassname}_EnterStartState(struct ${fsm.fsmClassname}*);
]],
            _transition_context = "${isntDefault?_transition_context_if()}\n",
            _transition_context_if = [[
extern void ${fsm.fsmClassname}_${name}(struct ${fsm.fsmClassname}*${parameters:_parameter_proto()});
]],
    }
end
