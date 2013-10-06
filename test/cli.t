#!/usr/bin/env lua

require 'Test.More'
require 'io'
require 'os'

plan(21)

local lua = arg[-1]
local smc = lua .. " ./bin/smc"

f = io.open('file.sm', 'w')
f:write([[

%class TestClass
%start Map_1::State_1

%map Map_1
%%
// State        Transition      End State       Action
State_1
{
                Evt_1           State_2         { Output("State_1:Evt_1"); }
}

State_2
{
                Evt_1           State_1         { Output("State_2:Evt_1"); }
}

%%
]])
f:close()

dump = [[
Start State: Map_1::State_1
    Context: TestClass
       Maps:
%map Map_1
Evt_1()
Evt_1 set State_2 {
    Output("State_1:Evt_1");
}
Evt_1()
Evt_1 set State_1 {
    Output("State_2:Evt_1");
}
]]


cmd = smc .. " -version"
f = io.popen(cmd)
like( f:read'*l', "^Smc %d%.%d%.%d", "-version" )
is( f:read'*l', nil )
f:close()

cmd = smc .. " -help"
f = io.popen(cmd)
like( f:read'*l', "^usage: Smc", "-help" )
f:close()

cmd = smc .. " no_file.sm"
f = io.popen(cmd)
is( f:read'*l', "Smc has experienced a fatal error." )
like( f:read'*l', "^Smc %d%.%d%.%d" )
like( f:read'*l', "Target language was not specified", "no target lang" )
is( f:read'*l', nil )
f:close()

cmd = smc .. " -lua -scala no_file.sm"
f = io.popen(cmd)
is( f:read'*l', "Smc has experienced a fatal error." )
like( f:read'*l', "^Smc %d%.%d%.%d" )
like( f:read'*l', "Only one target language may be specified", "2 target lang" )
is( f:read'*l', nil )
f:close()

cmd = smc .. " -lua no_file.sm"
f = io.popen(cmd)
is( f:read'*l', "Smc has experienced a fatal error." )
like( f:read'*l', "^Smc %d%.%d%.%d" )
like( f:read'*l', "Source file \"no_file.sm\" is not readable", "no file" )
is( f:read'*l', nil )
f:close()

cmd = smc .. " -lua -dump file.sm"
f = io.popen(cmd)
is( f:read'*a', dump, " -dump" )
f:close()

cmd = smc .. " -lua -verbose file.sm"
f = io.popen(cmd)
is( f:read'*l', "[parsing started file.sm]", "-verbose" )
is( f:read'*l', "[parsing completed]" )
is( f:read'*l', "[checking file.sm]" )
is( f:read'*l', "[wrote ./file_sm.lua]" )
is( f:read'*l', nil )
f:close()

os.remove 'file.sm'
os.remove 'file_sm.lua'
