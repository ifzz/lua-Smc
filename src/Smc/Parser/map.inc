

%map MapsMap
%%

MapStart
{
    MAP_NAME(token)
        MapName
        {}

    Default
        MapStartError
        {
            _error("Expecting %map.");
        }
}

MapStartError
{
    MAP_NAME(token)
        MapName
        {}

    Default
        nil
        {}
}

MapName
{
    WORD(token)
        MapStates
        {
            createMap(token);
        }

    EOD(token)
        States
        {
            _error("Name expected after \"%map\".");
            createMap("no_named");
        }

    Default
        nil
        {
            _error("Name expected after \"%map\".");
        }
}

MapStates
{
    EOD(token)
        States
        {}

    WORD(token)
        StateStart
        {
            _error("Expecting %% after \"%map mapname\".");
            createState(token);
        }

    Default
        MapStatesError
        {
            _error("Expecting %% after \"%map mapname\".");
        }
}

MapStatesError
{
    EOD(token)
        States
        {}

    MAP_NAME(token)
        MapName
        {
            addMap();
        }

    WORD(token)
        StateStart
        {
            createState(token);
        }

    Default
        nil
        {}
}

States
{
    // The "%%" means we have reached the end of this map's
    // definition.
    EOD(token)
        MapStart
        {
            addMap();
        }

    WORD(token)
        StateStart
        {
            createState(token);
        }

    // Error transitions.
    ENTRY(token)
        EntryStart
        {
            _error("Expecting either a new state definition or end of map (%%).");
            createState(token);
        }

    EXIT(token)
        ExitStart
        {
            _error("Expecting either a new state definition or end of map (%%).");
            createState(token);
        }

    LEFT_BRACE(token)
//        Transitions
        TransEnd/push(TransitionsMap::Start)
        {
            _error("Expecting either a new state definition or end of map (%%).");
            createState(token);
        }

    //~ EQUAL(token)
        //~ Transitions
        //~ {
            //~ _error("Expecting either a new state definition or end of map (%%).");
            //~ createState(token);
        //~ }

    MAP_NAME(token)
        MapName
        {
            _error("Expecting \"%%\" before another \"%map\".");
            addMap();
        }

    Default
        nil
        {
            _error("Expecting either a new state definition or end of map (%%).");
        }
} // end of state States

StateStart
{
    // This state has an entry actions.
    ENTRY(token)
        EntryStart
        {}

    // This state has an exit action.
    EXIT(token)
        ExitStart
        {}

    // The left brace marks the start of the transitions.
    LEFT_BRACE(token)
//        Transitions
        TransEnd/push(TransitionsMap::Start)
        {}

    Default
        StateStartError
        {
            _error("After the state name is given, then either an entry action, exit action or opening brace is expected.");
        }
} // end of state StateStart

StateStartError
{
    ENTRY(token)
        EntryStart
        {}

    EXIT(token)
        ExitStart
        {}

    LEFT_BRACE(token)
//        Transitions
        TransEnd/push(TransitionsMap::Start)
        {}

    Default
        nil
        {}
} // end of state StateStartError

TransEnd
{   // pop from TransitionsMap
    transitionsDone
        States
        {
            addState();
        }
}

EntryStart
{
    LEFT_BRACE(token)
        EntryEnd/push(ActionsMap::Start)
        {
            createActionList();
        }

    Default
        StateStartError
        {
            _error("An opening brace is expected after Entry.");
        }
}

EntryEnd
{   // pop from ActionsMap
    actionsDone
        StateStart
        {
            setEntryAction();
        }

    actionsError
//        StartState
        MapStartError
        {}
}

ExitStart
{
    LEFT_BRACE(token)
        ExitEnd/push(ActionsMap::Start)
        {
            createActionList();
        }

    Default
        StateStartError
        {
            _error("A opening brace is expected after Exit.");
        }
}

ExitEnd
{   // pop from ActionsMap
    actionsDone
        StateStart
        {
            setExitAction();
        }

    actionsError
//        StateStart
        MapStartError
        {}
}

%% // end of map MapsMap
