
%map TransitionsMap
%%

//Transitions
Start
{
    // A '}' is the end of the transitions.
    // Look for the next state.
    RIGHT_BRACE(token)
//        States
        pop(transitionsDone)
        {
//            addState();
        }

    // This is the transition name.
    WORD(token)
        TransStart
        {
            storeTransitionName(token);
        }

    Default
        TransError
        {
            _error("Expecting either a new transition or a closing brace.");
        }
} // end of state Transitions

TransError
{
    RIGHT_BRACE(token)
//        States
        pop(transitionsDone)
        {
            addState();
        }

    WORD(token)
        TransStart
        {
            storeTransitionName(token);
        }

    Default
        nil
        {}
} // end of state TransError

TransStart
{
    // A '(' means this transition has parameters.
    LEFT_PAREN(token)
        TransParams/push(ParamsMap::Start)
        {
            createParamList();
        }

    // A '[' denotes a guard. Since the code between the brackets
    // may be raw source code, place the lexer in raw source code
    // mode. This means the lexer will not process the characters
    // by passing them through the lexer FSM.
    LEFT_BRACKET(token)
        TransGuard
        {
            createTransition();
        }

    // NOTE: Now that SMC allows guards to be complex condition
    // expressions, it is no longer possible to check for
    // duplicate guards.

    PUSH(token)
        PushStart
        {
            createTransition();
            createGuard();
            setTransType("TRANS_PUSH");
//            setEndState("nil");
            setEndState();
        }

    POP(token)
        PopStart
        {
            createTransition();
            createGuard();
            setTransType("TRANS_POP");
        }

    JUMP(token)
        JumpStart
        {
            createTransition();
            createGuard();
            setTransType("TRANS_SET");
        }

    // This word is the end state. Now get the actions.
    WORD(token)
        SimpleTrans
        {
            createTransition();
            createGuard();
            setTransType("TRANS_SET");
            setEndState(token);
        }

    Default
        TransStartError
        {
            _error("Expecting either a guard, \"push\", \"pop\", \"jump\" or end state.");

            // Need to create a dummy transition so that _error
            // handling will function.
            createTransition();
        }
} // end of state TransStart

TransStartError
{
    // A '(' means this transition has parameters.
    LEFT_PAREN(token)
        TransParams/push(ParamsMap::Start)
        {
            createParamList();
        }

    // A '[' means this transition is guarded. Have the lexer
    // collect the raw source code.
    LEFT_BRACKET(token)
        TransGuard
        {}

    // A '{' is the start of the transition actions.
    LEFT_BRACE(token)
        ActionEnd/push(ActionsMap::Start)
        {
            createGuard();
            setTransType("TRANS_SET");
//            setEndState("End state missing");
            setEndState();

            createActionList();
        }

    PUSH(token)
        PushStart
        {
            createGuard();
            setTransType("TRANS_PUSH");
//            setEndState("nil");
            setEndState();
        }

    POP(token)
        PopStart
        {
            createGuard();
            setTransType("TRANS_POP");
        }

    JUMP(token)
        JumpStart
        {
            createGuard();
            setTransType("TRANS_SET");
//            setEndState("nil");
            setEndState();
        }

    // One way or another this transition is now kaput.
    RIGHT_BRACE(token)
//        Transitions
        Start
//        pop(transitionsDone)
        {
            addGuard();
            addTransition();
        }

    Default
        nil
        {}
} // end of state TransStartError

// Wait here for the transition parameter list to be returned.
TransParams
{
    // The "Default" transition may not have parameters.
    // But create a bogus transition before continuing.
//    paramsDone(params)
//      [ctxt:getTransitionName() == "Default"
//       and not params.isEmpty()]
//        TransNext
//        {
//            _error("Default transitions may not have parameters.");
//            createTransition();
//        }
//             XXX : move to Checker XXX

    paramsDone
        TransNext
        {
            createTransition();
        }

    // Create a bogus transition and keep going.
    paramsError()
        TransNext
        {
            createTransition();
        }
} // end of state TransParams

TransNext
{
    // A bracket denotes a guard.
    LEFT_BRACKET(token)
        TransGuard
        {}

    // NOTE: Now that SMC allows guards to be complex condition
    // expressions, it is no longer possible to check for
    // duplicate guards.

    PUSH(token)
        PushStart
        {
            createGuard();
            setTransType("TRANS_PUSH");
//            setEndState("nil");
            setEndState();
        }

    POP(token)
        PopStart
        {
            createGuard();
            setTransType("TRANS_POP");
        }

    JUMP(token)
        JumpStart
        {
            createGuard();
            setTransType("TRANS_SET");
//            setEndState("nil");
            setEndState();
        }

    // This word is the end state. Now get the actions.
    WORD(token)
        SimpleTrans
        {
            createGuard();
            setTransType("TRANS_SET");
            setEndState(token);
        }

    Default
        TransNextError
        {
            _error("Expecting either a guard, \"push\", \"pop\", \"jump\" or end state.");
        }
} // end of state TransNext

TransNextError
{
    // Transition parameters have already been defined.
    LEFT_PAREN(token)
        nil
        {}

    // A bracket means this transition is guarded.
    LEFT_BRACKET(token)
        TransGuard
        {}

    PUSH(token)
        PushStart
        {
            createGuard();
            setTransType("TRANS_PUSH");
//            setEndState("nil");
            setEndState();
        }

    POP(token)
        PopStart
        {
            createGuard();
            setTransType("TRANS_POP");
        }

    JUMP(token)
        JumpStart
        {
            createGuard();
            setTransType("TRANS_SET");
//            setEndState("nil");
            setEndState();
        }

    WORD(token)
        SimpleTrans
        {
            createGuard();
            setTransType("TRANS_SET");
            setEndState(token);
        }

    Default
        nil
        {}
} // end of state TransNextError

// Because the lexer is operating in raw mode, the lexer will
// return either a SOURCE token or an ERROR token. Since ERROR
// tokens are not passed into this FSM, then only the SOURCE
// token must be handled.
TransGuard
    Entry
    {
        setRawMode();
    }
    //~ Exit
    //~ {
        //~ setCookedMode();
    //~ }
{
    SOURCE(token)
        EndState
        {
            createGuard(token);
        }
} // end of state TransGuard

EndState
{
    // NOTE: Now that SMC allows guards to be complex condition
    // expressions, it is no longer possible to check for
    // duplicate guards.
    PUSH(token)
        PushStart
        {
            setTransType("TRANS_PUSH");
//            setEndState("nil");
            setEndState();
        }

    POP(token)
        PopStart
        {
            setTransType("TRANS_POP");
        }

    JUMP(token)
        JumpStart
        {
            setTransType("TRANS_SET");
//            setEndState("nil");
            setEndState();
        }

    WORD(token)
        SimpleTrans
        {
            setTransType("TRANS_SET");
            setEndState(token);
        }

    Default
        EndStateError
        {
            _error("Expecting either \"push\", \"pop\", \"jump\" or end state.");
        }
} // end of state EndState

EndStateError
{
    LEFT_BRACE(token)
        ActionEnd/push(ActionsMap::Start)
        {
            createActionList();
        }

    Default
        nil
        {}
} // end of state EndStateError

SimpleTrans
{
    // A slash means that this is really a push transition.
    SLASH(token)
        PushTransition
        {
            setTransType("TRANS_PUSH");
        }

    // A brace denotes the start of the actions.
    LEFT_BRACE(token)
        ActionEnd/push(ActionsMap::Start)
        {
            createActionList();
        }

    Default
        ActionStartError
        {
            _error("An opening brace must proceed any action definitions.");
        }
} // end of state SimpleTrans

// This is the push part of a "<state1>/push(<state2>)" end statefd
// <state1> has been parse, now look for the push.
PushTransition
{
    PUSH(token)
        PushStart
        {}

    Default
        PushError
        {
            _error("\"push\" must follow a '/'.");
        }
} // end of state PushTransition

PushStart
{
    LEFT_PAREN(token)
        PushMap
        {}

    Default
        PushError
        {
            _error("\"push\" must be followed by a '/'.");
        }
} // end of state PushStart

PushError
{
    RIGHT_PAREN(token)
        ActionStart
        {}

    LEFT_BRACE(token)
        ActionEnd/push(ActionsMap::Start)
        {
            createActionList();
        }

    Default
        nil
        {}
} // end of state PushError

PushMap
{
    WORD(token)
        PushEnd
        {
            setPushState(token);
        }

    Default
        PushError
        {
            _error("Expecting a state name.");
        }
} // end of state PushMap

PushEnd
{
    RIGHT_PAREN(token)
        ActionStart
        {}

    Default
        PushError
        {
            _error("push transition missing closing paren.");
        }
} // end of state PushEnd

// Must be a dead battery ...
JumpStart
{
    LEFT_PAREN(token)
        JumpMap
        {}

    Default
        JumpError
        {
            _error("\"jump\" must be followed by a '/'.");
        }
} // end of state JumpStart

// Must have reversed the leads ...
JumpError
{
    RIGHT_PAREN(token)
        ActionStart
        {}

    LEFT_BRACE(token)
        ActionEnd/push(ActionsMap::Start)
        {
            createActionList();
        }

    Default
        nil
        {}
} // end of state JumpError

JumpMap
{
    WORD(token)
        JumpEnd
        {
            setEndState(token);
        }

    Default
        JumpError
        {
            _error("Expecting a state name.");
        }
} // end of state JumpMap

JumpEnd
{
    RIGHT_PAREN(token)
        ActionStart
        {}

    Default
        JumpError
        {
            _error("jump transition missing closing paren.");
        }
} // end of state JumpEnd

PopStart
{
    LEFT_PAREN(token)
        PopAction
        {}

    // A brace denotes the start of the actions.
    // It is acceptable not to provide a pop transition.
    LEFT_BRACE(token)
        ActionEnd/push(ActionsMap::Start)
        {
            createActionList();
        }

    Default
        PopError
        {
            _error("Expecting '(trans)' or opening brace after pop.");
        }
} // end of state PopStart

PopError
{
    RIGHT_PAREN(token)
        ActionStart
        {}

    LEFT_BRACE(token)
        ActionEnd/push(ActionsMap::Start)
        {
            createActionList();
        }

    Default
        nil
        {}
} // end of state PopError

PopAction
{
    RIGHT_PAREN(token)
        ActionStart
        {}

    WORD(token)
        PopArgs
        {
            setEndState(token);
        }

    Default
        PopError
        {
            _error("Expecting either a pop transition or closing paren.");
        }
} // end of state PopAction

PopArgs
{
    // No more pop arguments. Start collecting the actions.
    RIGHT_PAREN(token)
        ActionStart
        {}

    // A comma signifies there are more arguments in this
    // transition.
    COMMA(token)
//        PopArgsEnd
//        {}
        PopArgsEnd/push(ArgsMap::Start)
        {
            createArgList();
        }

    Default
        PopError
        {
            _error("Pop transition missing closing paren.");
        }
} // end of state PopArgs

PopArgsEnd
{   // pop from ArgsMap
    argsDone
        ActionStart
        {
            setPopArgs();
        }

    argsError
        PopError
        {
            _error("Pop transition missing closing paren.");
        }
}

ActionStart
{
    // A brace denotes the start of the actions.
    LEFT_BRACE(token)
        ActionEnd/push(ActionsMap::Start)
        {
            createActionList();
        }

    Default
        ActionStartError
        {
            _error("An opening brace must proceed any action definitions.");
        }
} // end of state ActionStart

ActionEnd
{
    actionsDone
//        Transitions
        Start
//        pop(transitionDone)
        {
            setActions();
            addGuard();
            addTransition();
        }

    actionsError
//        Transitions
        Start
//        pop(transitionDone)
        {}
} // end of state ActionEnd

ActionStartError
{
    LEFT_BRACE(token)
        ActionEnd/push(ActionsMap::Start)
        {
            createActionList();
        }

    Default
        nil
        {}
} // end of state ActionStartError

%% // end of map TransitionMap

