
require 'Coat'
local CodeGen = require 'CodeGen'

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
${fsm.maps/_map()}
${_context()}

/*
 * Local variables:
 *  buffer-read-only: t
 * End:
 */
]],
        _preamble = [[
${fsm.source}
${fsm.includeList/_include()}
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
    ${fsm.transitions/_populate_transition()}
    state##_Default

${fsm.hasEntryActions?_def_entry()!_def_no_entry()}

${fsm.hasExitActions?_def_exit()!_def_no_exit()}
${fsm.transitions/_transition_base_state()}

static void ${fsm._package?_package()}${fsm.context}State_Default(struct ${fsm._package?_package()}${fsm.fsmClassname}* const fsm)
{
    ${generator.debugLevel0?_base_state_debug()}
    State_Default(fsm);
}
]],
            _package = "${fsm._package; format=scoped}_",
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

static void ${fsm._package?_package()}${fsm.context}State_${name}(struct ${fsm._package?_package()}${fsm.fsmClassname}* const fsm${parameters/_parameter_proto()})
{
    getState(fsm)->Default(fsm);
}
]],
                _parameter_proto = ", ${_type} ${name}",
            _base_state_debug = [[
if (getDebugFlag(fsm) != 0) {
    TRACE("TRANSITION   : %s.%s()\n", getName(getState(fsm)), getTransition(fsm));
}
]],
        _map = [[
${defaultState?_map_default_state()}
${states/_state()}
]],
            _map_default_state = [[

${fsm.transitions/_transition_default_def()}
#define ${fsm._package?_package()}${name}_DefaultState_Default ${fsm._package?_package()}${fsm.context}State_Default
${defaultState.transitions/_transition()}
]],
                _transition_default_def = "${isntDefault?_transition_default_def_if()}\n",
                _transition_default_def_if = [[
#define ${fullName; format=scoped}_DefaultState_${name} ${fsm._package?_package()}${fsm.context}State_${name}
]],
        _state = [[

${fsm.transitions/_transition_def()}
#define ${fullName; format=scoped}_Default ${map.defaultState?_default_state_name()!_base_state_name()}_Default
#define ${fullName; format=scoped}_Entry NULL
#define ${fullName; format=scoped}_Exit NULL
${entryActions?_state_entry()}
${exitActions?_state_exit()}
${transitions/_transition()}

const struct ${fsm._package?_package()}${fsm.context}State ${fullName; format=scoped} = { POPULATE_STATE(${fullName; format=scoped}), ${map.nextStateId}${generator.debugLevel0?_state_init_debug()} };
]],
            _state_init_debug = [[, "${fullName}"]],
            _transition_def = "${isntDefault?_transition_def_if()}\n",
            _transition_def_if = [[
#define ${fullName; format=scoped}_${name} ${map.defaultState?_default_state_name()!_base_state_name()}_${name}
]],
                _default_state_name = "${map.fullName; format=scoped}_DefaultState",
                _base_state_name = "${fsm._package?_package()}${fsm.context}State",
            _state_entry = [[

#undef ${fullName; format=scoped}_Entry
void  ${fullName; format=scoped}_Entry(struct ${fsm._package?_package()}${fsm.fsmClassname}* const fsm)
{
    struct ${fsm._package?_package()}${fsm.context}* ctxt = getOwner(fsm);

    ${entryActions/_action()}
}
]],
            _state_exit = [[

#undef ${fullName; format=scoped}_Exit
void ${fullName; format=scoped}_Exit(struct ${fsm._package?_package()}${fsm.fsmClassname}* const fsm)
{
    struct ${fsm._package?_package()}${fsm.context}* ctxt = getOwner(fsm);

    ${exitActions/_action()}
}
]],
        _transition = [[

#undef ${state.fullName; format=scoped}_${name}
static void ${state.fullName; format=scoped}_${name}(struct ${fsm._package?_package()}${fsm.fsmClassname}* const fsm${parameters/_parameter_proto()})
{
    ${hasCtxtReference?_transition_ctxt()}
    ${generator.debugLevel0?_transition_debug()}
    ${guards/_guard()}
    ${needFinalElse?_transition_else()}
}
]],
            _transition_ctxt = [[
struct ${fsm._package?_package()}${fsm.context}* ctxt = getOwner(fsm);
]],
            _transition_debug = [[
if (getDebugFlag(fsm) != 0) {
    TRACE("LEAVING STATE   : ${state.fullName}\n");
}
]],
            _transition_else = [[
else {
    ${fsm._package?_package()}${state.isDefault?_super_default()!_super()}_${name}(fsm${parameters/_parameter_call()});
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
const struct ${fsm._package?_package()}${fsm.context}State* endState = getState(fsm);

]],
                _guard_exit = [[
${generator.debugLevel1?_guard_debug_before_exit()}
EXIT_STATE(getState(fsm));
${generator.debugLevel1?_guard_debug_after_exit()}
]],
                    _guard_debug_before_exit = [[
if (getDebugFlag(fsm) != 0) {
    TRACE("BEFORE EXIT     : ${transition.state.fullName}.Exit()\n");
}
]],
                    _guard_debug_after_exit = [[
if (getDebugFlag(fsm) != 0) {
    TRACE("AFTER EXIT      : ${transition.state.fullName}.Exit()\n");
}
]],
                _guard_debug_enter = [[
if (getDebugFlag(fsm) != 0) {
    TRACE("ENTER TRANSITION: ${transition.state.fullName}.${transition.name}(${transition.parameters/_guard_debug_param(); separator=', '})\n");
}
]],
                    _guard_debug_param = "${name}",
                _guard_no_action = "${isConditional?_guard_no_action_if()}",
                    _guard_no_action_if = [[
/* No actions. */
]],
                _guard_actions = [[
clearState(fsm);
${actions/_action()}
]],
                _guard_debug_exit = [[
if (getDebugFlag(fsm) != 0) {
    TRACE("EXIT TRANSITION : ${transition.state.fullName}.${transition.name}(${transition.parameters/_guard_debug_param(); separator=', '})\n");
}
]],
                _guard_set = [[
setState(fsm, ${needVarEndState?_end_state_var()!_end_state_no_var()});
]],
                    _end_state_var = "endState",
                    _end_state_no_var = "&${fsm._package?_package()}${endStateName; format=scoped}",
                scoped = function (s) return s:gsub("::", "_") end,
                _guard_push = [[
${doesPushSet?_guard_set()}
${doesPushEntry?_guard_entry()}
pushState(fsm, &${fsm._package?_package()}${pushStateName; format=scoped});
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
    TRACE("BEFORE ENTRY    : ${transition.state.fullName}.Entry()\n");
}
]],
                    _guard_debug_after_entry = [[
if (getDebugFlag(fsm) != 0) {
    TRACE("AFTER ENTRY     : ${transition.state.fullName}.Entry()\n");
}
]],
                _guard_end_pop = [[
${fsm._package?_package()}${fsm.fsmClassname}_${endStateName}(fsm${popArgs; format=with_arg});
]],
                with_arg = function (s)
                    if s == '' then
                        return s
                    else
                        return ", " .. s
                    end
                end,
        _action = "${isEmptyStateStack?_action_ess()!_action_no_ess()}\n",
            _action_ess = [[
emptyStateStack(fsm);
]],
            _action_no_ess = [[
${fsm._package?_package()}${fsm.context}_${name}(ctxt${hasArguments?_action_arg()});
]],
                _action_arg = ", ${arguments; separator=', '}",
        _context = [[

#ifdef NO_${generator.targetfileBase; format=guarded}_MACRO
void ${fsm._package?_package()}${fsm.fsmClassname}_Init(struct ${fsm._package?_package()}${fsm.fsmClassname}* const fsm, struct ${fsm._package?_package()}${fsm.context}* const owner)
{
    FSM_INIT(fsm, &${fsm._package?_package()}${fsm.startState; format=scoped});
    fsm->_owner = owner;
}
${fsm.hasEntryActions?_enter_start()}
${fsm.transitions/_transition_context()}
#endif
]],
            guarded = function (s)
                s = s:gsub("\\", "_")
                s = s:gsub("/", "_")
                return s:upper()
            end,
            _enter_start = [[

void ${fsm._package?_package()}${fsm.fsmClassname}_EnterStartState(struct ${fsm._package?_package()}${fsm.fsmClassname}* const fsm)
{
    ENTRY_STATE(getState(fsm));
}
]],
            _transition_context = "${isntDefault?_transition_context_if()}\n",
            _transition_context_if = [[

void ${fsm._package?_package()}${fsm.fsmClassname}_${name}(struct ${fsm._package?_package()}${fsm.fsmClassname}* const fsm${parameters/_parameter_context_proto()})
{
    const struct ${fsm._package?_package()}${fsm.context}State* state = getState(fsm);

    assert(state != NULL);
    setTransition(fsm, "${name}");
    state->${name}(fsm${parameters/_parameter_context_call()});
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
${fsm.maps/_map()}
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
#include <assert.h>
${generator.debugLevel0?_define_name()}
#include <statemap.h>

${fsm.declareList/_declare()}
]],
            _define_name = [[
#define STATEMAP_DEBUG 1
]],
            _declare = "${it}\n",
        _base_state = [[
struct ${fsm._package?_package()}${fsm.context};
struct ${fsm._package?_package()}${fsm.fsmClassname};

struct ${fsm._package?_package()}${fsm.context}State
{
    ${fsm.hasEntryActions?_member_entry()}
    ${fsm.hasExitActions?_member_exit()}
    ${fsm.transitions/_transition_member()}
    void(*Default)(struct ${fsm._package?_package()}${fsm.fsmClassname}* const fsm);
    STATE_MEMBERS
};

]],
            _package = "${fsm._package; format=scoped}_",
            scoped = function (s) return s:gsub("::", "_") end,
            _member_entry = [[
void(*Entry)(struct ${fsm._package?_package()}${fsm.fsmClassname}* const fsm);
]],
            _member_exit = [[
void(*Exit)(struct ${fsm._package?_package()}${fsm.fsmClassname}* const fsm);
]],
            _transition_member = "${isntDefault?_transition_member_if()}\n",
            _transition_member_if = [[
void(*${name})(struct ${fsm._package?_package()}${fsm.fsmClassname}* const fsm ${parameters/_parameter_proto()});
]],
                _parameter_proto = ", ${_type} ${name}",
        _map = "${states/_state()}\n",
        _state = [[
extern const struct ${fsm._package?_package()}${fsm.context}State ${fullName; format=scoped};
]],
        _context = [[

struct ${fsm._package?_package()}${fsm.fsmClassname}
{
    struct ${fsm._package?_package()}${fsm.context} *_owner;
    FSM_MEMBERS(${fsm._package?_package()}${fsm.context})
};

#ifdef NO_${generator.targetfileBase; format=guarded}_MACRO
extern void ${fsm._package?_package()}${fsm.fsmClassname}_Init(struct ${fsm._package?_package()}${fsm.fsmClassname}* const fsm, struct ${fsm._package?_package()}${fsm.context}* const owner);
${fsm.hasEntryActions?_enter_start_proto()}
${fsm.transitions/_transition_context_proto()}
#else
#define ${fsm._package?_package()}${fsm.fsmClassname}_Init(fsm, owner) \
    FSM_INIT((fsm), &${fsm._package?_package()}${fsm.startState; format=scoped}); \
    (fsm)->_owner = (owner);
${fsm.hasEntryActions?_enter_start()}
${fsm.transitions/_transition_context()}
#endif
]],
            _enter_start_proto = [[
extern void ${fsm._package?_package()}${fsm.fsmClassname}_EnterStartState(struct ${fsm._package?_package()}${fsm.fsmClassname}* const fsm);
]],
            _transition_context_proto = "${isntDefault?_transition_context_proto_if()}\n",
            _transition_context_proto_if = [[
extern void ${fsm._package?_package()}${fsm.fsmClassname}_${name}(struct ${fsm._package?_package()}${fsm.fsmClassname}* const fsm ${parameters/_parameter_proto()});
]],
            _enter_start = [[

#define ${fsm._package?_package()}${fsm.fsmClassname}_EnterStartState(fsm) \
    ENTRY_STATE(getState(fsm));
]],
            _transition_context = "${isntDefault?_transition_context_if()}\n",
            _transition_context_if = [[

#define ${fsm._package?_package()}${fsm.fsmClassname}_${name}(fsm${parameters/_parameter_context_def()}) \
    assert(getState(fsm) != NULL); \
    ${generator.debugLevel0?_transition_debug_set()}
    getState(fsm)->${name}((fsm)${parameters/_parameter_context_call()});${generator.debugLevel0?_backslash()}
    ${generator.debugLevel0?_transition_debug_unset()}
]],
                _parameter_context_def = ", ${name}",
                _parameter_context_call = ", (${name})",
                _backslash = [[ \]],
                _transition_debug_set = [[
setTransition((fsm), "${name}"); \
]],
                _transition_debug_unset = [[
setTransition((fsm), NULL);
]],
    }
end
