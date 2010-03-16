
%map HeaderMap
%%

Start
{
    SOURCE(token)
        nil
        {
            setSource(token);
        }

    CLASS_NAME(token)
        Context
        {}

    START_STATE(token)
        StartState
        {}

    FSM_CLASS_NAME(token)
        FsmClassName
        {}

    HEADER_FILE(token)
        HeaderFile
        {}

    INCLUDE_FILE(token)
        IncludeFile
        {}

    PACKAGE_NAME(token)
        Package
        {}

    IMPORT(token)
        Import
        {}

    DECLARE(token)
        Declare
        {}

    ACCESS(token)
        Access
        {}

    MAP_NAME(token)
        push(MapsMap::MapName)
        {}

    Default
        StartError
        {
            _error("Expecting \"%{ source %}\", %start, or %class.");
        }
} // end of state Start

Context
{
    WORD(token)
        Start
        {
            setContext(token);
        }

    Default
        StartError
        {
            _error("Missing name after %class.");
        }
}

StartState
{
    WORD(token)
        Start
        {
            setStartState(token);
        }

    Default
        StartError
        {
            _error("Missing state after %start.");
        }
}

HeaderFile
    Entry
    {
        setRawMode3();
    }
{
    SOURCE(token)
        Start
        {
            setHeader(token);
        }
}

IncludeFile
    Entry
    {
        setRawMode3();
    }
{
    SOURCE(token)
        Start
        {
            addInclude(token);
        }
}

Package
{
    WORD(token)
        Start
        {
            setPackageName(token);
        }

    Default
        StartError
        {
            _error("Missing name after %package.");
        }
}

FsmClassName
{
    WORD(token)
        Start
        {
            setFsmClassName(token);
        }

    Default
        StartError
        {
            _error("Missing name after %FsmClassName.");
        }
}

Import
    Entry
    {
        setRawMode3();
    }
{
    SOURCE(token)
        Start
        {
            addImport(token);
        }
}

Declare
    Entry
    {
        setRawMode3();
    }
{
    SOURCE(token)
        Start
        {
            addDeclare(token);
        }
}

Access
    Entry
    {
        setRawMode3();
    }
{
    SOURCE(token)
        Start
        {
            setAccessLevel(token);
        }
}

// Remain in this state until a known good token is found.
StartError
{
    SOURCE(token)
        Start
        {
            setSource(token);
        }

    CLASS_NAME(token)
        Context
        {}

    START_STATE(token)
        StartState
        {}

    FSM_CLASS_NAME(token)
        FsmClassName
        {}

    HEADER_FILE(token)
        HeaderFile
        {}

    INCLUDE_FILE(token)
        IncludeFile
        {}

    PACKAGE_NAME(token)
        Package
        {}

    IMPORT(token)
        Import
        {}

    DECLARE(token)
        Declare
        {}

    ACCESS(token)
        Access
        {}

    MAP_NAME(token)
        Start/push(MapsMap::MapName)
        {}

    Default
        nil
        {}
} // end of state StartError

%% // end of map HeaderMap

