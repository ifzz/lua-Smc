#!/usr/bin/env lua

require 'Smc.Parser'

require 'Test.More'
require 'io'

plan(217)

local function do_parse (text, lang)
    local f = io.tmpfile()
    f:write(text)
    f:seek 'set'
    local parser = Smc.Parser.new{
        name = 'test',
        filename = '<tmpfile>',
        stream = f,
        targetLanguage = lang or 'LANG',
        targetFilename = 'test.out',
--        debugFlag = true,
    }
    assert(parser:isa 'Smc.Parser')
    local fsm = parser:parse()
    return parser, fsm
end

local function get_messages (parser)
    local t = {}
    for _, msg in ipairs(parser.messages) do
        table.insert(t, tostring(msg))
        table.insert(t, "\n")
    end
    return table.concat(t, '')
end


local parser, fsm = do_parse ""
is( get_messages(parser), '', "empty parse" )
ok( fsm:isa 'Smc.FSM' )
ok( fsm.isValid )
is( fsm.name, 'test' )
is( fsm.filename, '<tmpfile>' )
is( fsm.targetFilename, 'test.out' )
is( fsm.source, nil )
is( fsm.context, nil )
is( fsm.startState, nil )
is( fsm._package, nil )
is( fsm.accessLevel, nil )
is( #fsm.includeList, 0 )
is( #fsm.importList, 0 )
is( #fsm.declareList, 0 )
is( #fsm.maps, 0 )


parser, fsm = do_parse [===[

%{
raw code
%}

%class          AppClass
%start          StartMap::StartState
%fsmclass       AppContext

%package        net.sf.smc
%access         private

%header         AppClass.h

%import         java.util
%import         java.other

%include        <stdlib.h>
%include        "file.h"
%include        bare.h

%declare        extern var;
%declare        extern func()

]===]
is( get_messages(parser), '', "headers" )
ok( fsm.isValid )
is( fsm.source, "\nraw code\n" )
is( fsm.context, 'AppClass' )
is( fsm.startState, 'StartMap::StartState' )
is( fsm.fsmClassname, 'AppContext' )
is( fsm._package, 'net.sf.smc' )
is( fsm.accessLevel, 'private' )
is( fsm.header, 'AppClass.h' )
eq_array( fsm.includeList, {
    '<stdlib.h>',
    '"file.h"',
    '"bare.h"',
} )
eq_array( fsm.importList, {
    'java.util',
    'java.other',
} )
eq_array( fsm.declareList, {
    'extern var;',
    'extern func();',
} )
is( #fsm.maps, 0 )


parser, fsm = do_parse [===[

%{
raw code
%}

%class          AppClass
%start          StartMap::StartState

%package        net.sf.smc
%access         private

%header         AppClass.h

%{
another raw code
%}

%class          MyAppClass
%start          IdleMap::IdleState

%package        smc.sf.net
%access         public

%header         AppClass.hpp

]===]
is( get_messages(parser), [=[
<tmpfile>:14: warning - %{ %} source previously specified, new source ignored.
<tmpfile>:18: warning - %class previously specified, new context ignored.
<tmpfile>:19: warning - %start previously specified, new start state ignored.
<tmpfile>:21: warning - %package previously specified, new package ignored.
<tmpfile>:22: warning - %access previously specified, new access level ignored.
<tmpfile>:24: warning - %header previously specified, new header file ignored.
]=], "headers (duplicated)" )
ok( fsm.isValid )
is( fsm.source, "\nraw code\n" )
is( fsm.context, 'AppClass' )
is( fsm.startState, 'StartMap::StartState' )
is( fsm._package, 'net.sf.smc' )
is( fsm.accessLevel, 'private' )
is( fsm.header, 'AppClass.h' )


parser, fsm = do_parse [===[

%class          AppClass
%start          Map1::StartState

%map Map1
%%
    // empty map
%%

%map Map2
%%
    // empty map
%%

]===]
is( get_messages(parser), '', "empty maps" )
ok( fsm.isValid )
is( #fsm.maps, 2 )
local map = fsm.maps[1]
is( map.name, 'Map1' )
is( map.fsm, fsm )
is( map.defaultState, nil )
is( #map.states, 0 )
map = fsm.maps[2]
is( map.name, 'Map2' )


parser, fsm = do_parse [===[

%class          AppClass
%start          Map1::StartState

%map Map1
%%

StartState
{
    // empty state
}

IdleState
    Entry {
        action1();
        action2();
    }
    Exit {
        action3();
    }
{
    // no transition
}

Default
{
    // empty default state
}
%%

]===]
is( get_messages(parser), '', "map without transition" )
ok( fsm.isValid )
is( #fsm.maps, 1 )
local map = fsm.maps[1]
is( map.name, 'Map1' )
is( map.fsm, fsm )
ok( map.defaultState )
is( #map.states, 2 )
local state = map.states[1]
is( state.map, map )
is( state.className, 'StartState' )
is( state.instanceName, 'StartState' )
is( state.entryActions, nil )
is( state.exitActions, nil )
is( #state.transitions, 0 )
state = map.states[2]
is( state.className, 'IdleState' )
is( state.instanceName, 'IdleState' )
is( #state.entryActions, 2 )
local action = state.entryActions[1]
is( action.name, 'action1' )
action = state.entryActions[2]
is( action.name, 'action2' )
is( #state.exitActions, 1 )
action = state.exitActions[1]
is( action.name, 'action3' )
state = map.defaultState
is( state.className, 'Default' )
is( state.instanceName, 'DefaultState' )


parser, fsm = do_parse([===[

%class          AppClass
%start          Map1::StartState

%map Map1
%%

StartState
    Entry {
        action1( );
        action2(arg1, arg2);
        action3(param1, f2(param3), "str),ing" );
        prop1 = f(value);
        prop2 = expr1 + expr2;
    }
{
    // no transition
}

%%

]===], 'GRAPH')
is( get_messages(parser), '', "actions with args" )
ok( fsm.isValid )
is( #fsm.maps, 1 )
local map = fsm.maps[1]
is( #map.states, 1 )
local state = map.states[1]
is( #state.entryActions, 5 )
local action = state.entryActions[1]
is( action.name, 'action1' )
is( action.propertyFlag, false )
is( #action.arguments, 0 )
action = state.entryActions[2]
is( action.name, 'action2' )
is( #action.arguments, 2 )
is( action.arguments[1], 'arg1' )
is( action.arguments[2], 'arg2' )
action = state.entryActions[3]
is( action.name, 'action3' )
is( #action.arguments, 3 )
is( action.arguments[1], 'param1' )
is( action.arguments[2], 'f2(param3)' )
is( action.arguments[3], '"str),ing"' )
action = state.entryActions[4]
is( action.name, 'prop1' )
is( action.propertyFlag, true )
is( #action.arguments, 1 )
is( action.arguments[1], 'f(value)' )
action = state.entryActions[5]
is( action.name, 'prop2' )
is( action.propertyFlag, true )
is( #action.arguments, 1 )
is( action.arguments[1], 'expr1 + expr2' )


parser, fsm = do_parse([===[

%class          AppClass
%start          Map1::StartState

%map Map1
%%

StartState
{
    event1
                nil
                        {}

    event2()
                nil
                        {}

    event3(  param : type )
                nil
                        {}

    event4(param1:type1, $param2, param3: const type3)
                nil
                        {}

    Default (no_param)
                nil
                        {}
}

%%

]===], 'GRAPH')
is( get_messages(parser), [=[
<tmpfile>:26: error - Default transition with parameter.
]=], "transitions" )
nok( fsm.isValid )
is( #fsm.maps, 1 )
local map = fsm.maps[1]
is( #map.states, 1 )
local state = map.states[1]
is( state.instanceName, 'StartState' )
is( #state.transitions, 5 )
local transition = state.transitions[1]
is( transition.state, state )
is( transition.name, 'event1' )
is( #transition.parameters, 0 )
transition = state.transitions[2]
is( transition.name, 'event2' )
is( #transition.parameters, 0 )
transition = state.transitions[3]
is( transition.name, 'event3' )
is( #transition.parameters, 1 )
local param = transition.parameters[1]
is( param.name, 'param' )
is( param._type, 'type' )
transition = state.transitions[4]
is( transition.name, 'event4' )
is( #transition.parameters, 3 )
param = transition.parameters[1]
is( param.name, 'param1' )
is( param._type, 'type1' )
param = transition.parameters[2]
is( param.name, '$param2' )
is( param._type, nil )
param = transition.parameters[3]
is( param.name, 'param3' )
is( param._type, 'const type3' )
transition = state.transitions[5]
is( transition.name, 'Default' )
is( transition.state, state )
is( #transition.parameters, 1 )


parser, fsm = do_parse [===[

%class          AppClass
%start          Map1::StartState

%map Map1
%%

StartState
{
    event(param : type)
                nil
                        {}

    event(param : type)
        [guard]
                nil
                        {
                            action1();
                        }

    event(param : type)
        [guard[2] && f(param)]
                nil
                        {
                            action2();
                            action3();
                        }

    Default
                nil
                        {}
}

%%

]===]
is( get_messages(parser), '', "guards & actions" )
ok( fsm.isValid )
is( #fsm.maps, 1 )
local map = fsm.maps[1]
is( #map.states, 1 )
local state = map.states[1]
is( state.instanceName, 'StartState' )
is( #state.transitions, 2 )
local transition = state.transitions[1]
is( transition.name, 'event' )
is( #transition.parameters, 1 )
local param = transition.parameters[1]
is( param.name, 'param' )
is( param._type, 'type' )
is( #transition.guards, 3 )
local guard = transition.guards[1]
is( guard.transition, transition )
is( guard.transType, 'TRANS_SET' )
is( guard.condition, '' )
is( guard.endState, 'nil' )
is( #guard.actions, 0 )
guard = transition.guards[2]
is( guard.transition, transition )
is( guard.transType, 'TRANS_SET' )
is( guard.condition, 'guard' )
is( guard.endState, 'nil' )
is( #guard.actions, 1 )
local action = guard.actions[1]
is( action.name, 'action1' )
guard = transition.guards[3]
is( guard.transition, transition )
is( guard.transType, 'TRANS_SET' )
is( guard.condition, 'guard[2] && f(param)' )
is( guard.endState, 'nil' )
is( #guard.actions, 2 )
action = guard.actions[1]
is( action.name, 'action2' )
action = guard.actions[2]
is( action.name, 'action3' )
transition = state.transitions[2]
is( transition.name, 'Default' )
is( #transition.parameters, 0 )
is( #transition.guards, 1 )
guard = transition.guards[1]
is( guard.transition, transition )
is( guard.transType, 'TRANS_SET' )
is( guard.condition, '' )
is( guard.endState, 'nil' )
is( #guard.actions, 0 )


parser, fsm = do_parse [===[

%class          AppClass
%start          Map1::StartState

%map Map1
%%

StartState
{
    event1
                nil
                        {}

    event2
                IdleState
                        {}

    event3
                Map2::Start
                        {}

    event4
                jump(Map2::Start)
                        {}

    event5
                IdleState/push(Map2::Start)
                        {}

    event6
                push(Map2::Start)
                        {}

}

IdleState
{
    done
                nil
                        {}

    result(param : type)
                nil
                        {}

}

%%

%map Map2
%%

Start
{
    event1
                pop(done)
                        {}

    event2
                pop(result, param )
                        {}

    event3
                pop(result, param1, param2, param3)
                        {}
}

%%

]===]
is( get_messages(parser), '', "transitions with destination" )
ok( fsm.isValid )
is( #fsm.maps, 2 )
local map = fsm.maps[1]
is( map.name, 'Map1' )
is( #map.states, 2 )
local state = map.states[1]
is( state.instanceName, 'StartState' )
is( #state.transitions, 6 )
local transition = state.transitions[1]
is( transition.name, 'event1' )
local guard = transition.guards[1]
is( guard.transType, 'TRANS_SET' )
is( guard.endState, 'nil' )
is( guard.pushState, nil )
is( guard.popArgs, nil )
transition = state.transitions[2]
is( transition.name, 'event2' )
guard = transition.guards[1]
is( guard.transType, 'TRANS_SET' )
is( guard.endState, 'IdleState' )
is( guard.pushState, nil )
is( guard.popArgs, nil )
transition = state.transitions[3]
is( transition.name, 'event3' )
guard = transition.guards[1]
is( guard.transType, 'TRANS_SET' )
is( guard.endState, 'Map2::Start' )
is( guard.pushState, nil )
is( guard.popArgs, nil )
transition = state.transitions[4]
is( transition.name, 'event4' )
guard = transition.guards[1]
is( guard.transType, 'TRANS_SET' )
is( guard.endState, 'Map2::Start' )
is( guard.pushState, nil )
is( guard.popArgs, nil )
transition = state.transitions[5]
is( transition.name, 'event5' )
guard = transition.guards[1]
is( guard.transType, 'TRANS_PUSH' )
is( guard.endState, 'IdleState' )
is( guard.pushState, 'Map2::Start' )
is( guard.popArgs, nil )
transition = state.transitions[6]
is( transition.name, 'event6' )
guard = transition.guards[1]
is( guard.transType, 'TRANS_PUSH' )
is( guard.endState, 'nil' )
is( guard.pushState, 'Map2::Start' )
is( guard.popArgs, nil )
map = fsm.maps[2]
is( map.name, 'Map2' )
is( #map.states, 1 )
state = map.states[1]
is( state.instanceName, 'Start' )
is( #state.transitions, 3 )
transition = state.transitions[1]
is( transition.name, 'event1' )
guard = transition.guards[1]
is( guard.transType, 'TRANS_POP' )
is( guard.endState, 'done' )
is( guard.pushState, nil )
is( guard.popArgs, '' )
transition = state.transitions[2]
is( transition.name, 'event2' )
guard = transition.guards[1]
is( guard.transType, 'TRANS_POP' )
is( guard.endState, 'result' )
is( guard.pushState, nil )
is( guard.popArgs, 'param' )
transition = state.transitions[3]
is( transition.name, 'event3' )
guard = transition.guards[1]
is( guard.transType, 'TRANS_POP' )
is( guard.endState, 'result' )
is( guard.pushState, nil )
is( guard.popArgs, 'param1, param2, param3' )


local f = io.open("map1.inc", "w")
f:write [===[

%class          MyAppClass

%map Map1
%%
    // empty map
%%

]===]
f:close()
parser, fsm = do_parse [===[

%class          AppClass
%start          Map1::StartState

%source map1.inc

%map Map2
%%
    // empty map
%%

]===]
is( get_messages(parser), [=[
map1.inc:2: warning - %class previously specified, new context ignored.
]=], "source" )
ok( fsm.isValid )
is( #fsm.maps, 2 )
local map = fsm.maps[1]
is( map.name, 'Map1' )
map = fsm.maps[2]
is( map.name, 'Map2' )
os.remove "map1.inc"


parser, fsm = do_parse [===[

%source no_file.inc

%class          AppClass
%class          MyAppClass

]===]
is( get_messages(parser), [=[
<tmpfile>:2: error - Cannot open no_file.inc (no_file.inc: No such file or directory)
<tmpfile>:5: warning - %class previously specified, new context ignored.
]=], "source no_file" )
nok( fsm.isValid )

