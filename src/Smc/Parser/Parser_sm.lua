-- ex: set ro:
-- DO NOT EDIT.
-- from file : src/Smc/Parser/Parser.sm

local error = error
local tostring = tostring
local strformat = require 'string'.format

local statemap = require 'statemap'

module(...)

local ParserState = statemap.State:class()

function ParserState:Entry (fsm) end

function ParserState:Exit (fsm) end

function ParserState:CLASS_NAME (fsm, token)
    self:Default(fsm)
end

function ParserState:POP (fsm, token)
    self:Default(fsm)
end

function ParserState:EXIT (fsm, token)
    self:Default(fsm)
end

function ParserState:DOLLAR (fsm, token)
    self:Default(fsm)
end

function ParserState:SEMICOLON (fsm, token)
    self:Default(fsm)
end

function ParserState:RIGHT_PAREN (fsm, token)
    self:Default(fsm)
end

function ParserState:MAP_NAME (fsm, token)
    self:Default(fsm)
end

function ParserState:SOURCE (fsm, token)
    self:Default(fsm)
end

function ParserState:FSM_CLASS_NAME (fsm, token)
    self:Default(fsm)
end

function ParserState:argsDone (fsm)
    self:Default(fsm)
end

function ParserState:transitionsDone (fsm)
    self:Default(fsm)
end

function ParserState:argsError (fsm)
    self:Default(fsm)
end

function ParserState:actionsDone (fsm)
    self:Default(fsm)
end

function ParserState:EQUAL (fsm, token)
    self:Default(fsm)
end

function ParserState:EOD (fsm, token)
    self:Default(fsm)
end

function ParserState:COLON (fsm, token)
    self:Default(fsm)
end

function ParserState:RIGHT_BRACE (fsm, token)
    self:Default(fsm)
end

function ParserState:IMPORT (fsm, token)
    self:Default(fsm)
end

function ParserState:COMMA (fsm, token)
    self:Default(fsm)
end

function ParserState:WORD (fsm, token)
    self:Default(fsm)
end

function ParserState:PACKAGE_NAME (fsm, token)
    self:Default(fsm)
end

function ParserState:DECLARE (fsm, token)
    self:Default(fsm)
end

function ParserState:ENTRY (fsm, token)
    self:Default(fsm)
end

function ParserState:actionsError (fsm)
    self:Default(fsm)
end

function ParserState:LEFT_BRACKET (fsm, token)
    self:Default(fsm)
end

function ParserState:LEFT_BRACE (fsm, token)
    self:Default(fsm)
end

function ParserState:paramsError (fsm)
    self:Default(fsm)
end

function ParserState:PUSH (fsm, token)
    self:Default(fsm)
end

function ParserState:JUMP (fsm, token)
    self:Default(fsm)
end

function ParserState:INCLUDE_FILE (fsm, token)
    self:Default(fsm)
end

function ParserState:HEADER_FILE (fsm, token)
    self:Default(fsm)
end

function ParserState:paramsDone (fsm)
    self:Default(fsm)
end

function ParserState:LEFT_PAREN (fsm, token)
    self:Default(fsm)
end

function ParserState:SLASH (fsm, token)
    self:Default(fsm)
end

function ParserState:ACCESS (fsm, token)
    self:Default(fsm)
end

function ParserState:START_STATE (fsm, token)
    self:Default(fsm)
end

function ParserState:Default (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("TRANSITION   : Default\n")
    end
    local msg = strformat("Undefined Transition\nState: %s\nTransition: %s\n",
                          fsm:getState():getName(),
                          fsm:getTransition())
    error(msg)
end

local HeaderMap = {}
local MapsMap = {}
local TransitionsMap = {}
local ParamsMap = {}
local ActionsMap = {}
local ArgsMap = {}

HeaderMap.Default = ParserState:new('HeaderMap.Default', -1)

HeaderMap.Start = HeaderMap.Default:new('HeaderMap.Start', 1)

function HeaderMap.Start:SOURCE (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.Start:SOURCE(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:setSource(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.Start:SOURCE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(endState)
end

function HeaderMap.Start:CLASS_NAME (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.Start:CLASS_NAME(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.Start:CLASS_NAME(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(HeaderMap.Context)
    fsm:getState():Entry(fsm)
end

function HeaderMap.Start:START_STATE (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.Start:START_STATE(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.Start:START_STATE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(HeaderMap.StartState)
    fsm:getState():Entry(fsm)
end

function HeaderMap.Start:FSM_CLASS_NAME (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.Start:FSM_CLASS_NAME(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.Start:FSM_CLASS_NAME(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(HeaderMap.FsmClassName)
    fsm:getState():Entry(fsm)
end

function HeaderMap.Start:HEADER_FILE (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.Start:HEADER_FILE(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.Start:HEADER_FILE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(HeaderMap.HeaderFile)
    fsm:getState():Entry(fsm)
end

function HeaderMap.Start:INCLUDE_FILE (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.Start:INCLUDE_FILE(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.Start:INCLUDE_FILE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(HeaderMap.IncludeFile)
    fsm:getState():Entry(fsm)
end

function HeaderMap.Start:PACKAGE_NAME (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.Start:PACKAGE_NAME(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.Start:PACKAGE_NAME(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(HeaderMap.Package)
    fsm:getState():Entry(fsm)
end

function HeaderMap.Start:IMPORT (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.Start:IMPORT(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.Start:IMPORT(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(HeaderMap.Import)
    fsm:getState():Entry(fsm)
end

function HeaderMap.Start:DECLARE (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.Start:DECLARE(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.Start:DECLARE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(HeaderMap.Declare)
    fsm:getState():Entry(fsm)
end

function HeaderMap.Start:ACCESS (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.Start:ACCESS(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.Start:ACCESS(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(HeaderMap.Access)
    fsm:getState():Entry(fsm)
end

function HeaderMap.Start:MAP_NAME (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.Start\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.Start:MAP_NAME(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.Start:MAP_NAME(token=" .. tostring(token) .. ")\n")
    end
    fsm:pushState(MapsMap.MapName)
    fsm:getState():Entry(fsm)
end

function HeaderMap.Start:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.Start:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("Expecting \"%{ source %}\", %start, or %class.")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.Start:Default()\n")
    end
    fsm:setState(HeaderMap.StartError)
    fsm:getState():Entry(fsm)
end

HeaderMap.Context = HeaderMap.Default:new('HeaderMap.Context', 2)

function HeaderMap.Context:WORD (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.Context\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.Context:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:setContext(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.Context:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(HeaderMap.Start)
    fsm:getState():Entry(fsm)
end

function HeaderMap.Context:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.Context\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.Context:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("Missing name after %class.")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.Context:Default()\n")
    end
    fsm:setState(HeaderMap.StartError)
    fsm:getState():Entry(fsm)
end

HeaderMap.StartState = HeaderMap.Default:new('HeaderMap.StartState', 3)

function HeaderMap.StartState:WORD (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.StartState\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.StartState:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:setStartState(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.StartState:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(HeaderMap.Start)
    fsm:getState():Entry(fsm)
end

function HeaderMap.StartState:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.StartState\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.StartState:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("Missing state after %start.")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.StartState:Default()\n")
    end
    fsm:setState(HeaderMap.StartError)
    fsm:getState():Entry(fsm)
end

HeaderMap.HeaderFile = HeaderMap.Default:new('HeaderMap.HeaderFile', 4)

function HeaderMap.HeaderFile:Entry (fsm)
    local ctxt = fsm:getOwner()
    ctxt:setRawMode3()
end

function HeaderMap.HeaderFile:SOURCE (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.HeaderFile\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.HeaderFile:SOURCE(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:setHeader(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.HeaderFile:SOURCE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(HeaderMap.Start)
    fsm:getState():Entry(fsm)
end

HeaderMap.IncludeFile = HeaderMap.Default:new('HeaderMap.IncludeFile', 5)

function HeaderMap.IncludeFile:Entry (fsm)
    local ctxt = fsm:getOwner()
    ctxt:setRawMode3()
end

function HeaderMap.IncludeFile:SOURCE (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.IncludeFile\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.IncludeFile:SOURCE(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:addInclude(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.IncludeFile:SOURCE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(HeaderMap.Start)
    fsm:getState():Entry(fsm)
end

HeaderMap.Package = HeaderMap.Default:new('HeaderMap.Package', 6)

function HeaderMap.Package:WORD (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.Package\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.Package:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:setPackageName(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.Package:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(HeaderMap.Start)
    fsm:getState():Entry(fsm)
end

function HeaderMap.Package:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.Package\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.Package:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("Missing name after %package.")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.Package:Default()\n")
    end
    fsm:setState(HeaderMap.StartError)
    fsm:getState():Entry(fsm)
end

HeaderMap.FsmClassName = HeaderMap.Default:new('HeaderMap.FsmClassName', 7)

function HeaderMap.FsmClassName:WORD (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.FsmClassName\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.FsmClassName:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:setFsmClassName(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.FsmClassName:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(HeaderMap.Start)
    fsm:getState():Entry(fsm)
end

function HeaderMap.FsmClassName:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.FsmClassName\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.FsmClassName:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("Missing name after %FsmClassName.")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.FsmClassName:Default()\n")
    end
    fsm:setState(HeaderMap.StartError)
    fsm:getState():Entry(fsm)
end

HeaderMap.Import = HeaderMap.Default:new('HeaderMap.Import', 8)

function HeaderMap.Import:Entry (fsm)
    local ctxt = fsm:getOwner()
    ctxt:setRawMode3()
end

function HeaderMap.Import:SOURCE (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.Import\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.Import:SOURCE(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:addImport(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.Import:SOURCE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(HeaderMap.Start)
    fsm:getState():Entry(fsm)
end

HeaderMap.Declare = HeaderMap.Default:new('HeaderMap.Declare', 9)

function HeaderMap.Declare:Entry (fsm)
    local ctxt = fsm:getOwner()
    ctxt:setRawMode3()
end

function HeaderMap.Declare:SOURCE (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.Declare\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.Declare:SOURCE(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:addDeclare(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.Declare:SOURCE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(HeaderMap.Start)
    fsm:getState():Entry(fsm)
end

HeaderMap.Access = HeaderMap.Default:new('HeaderMap.Access', 10)

function HeaderMap.Access:Entry (fsm)
    local ctxt = fsm:getOwner()
    ctxt:setRawMode3()
end

function HeaderMap.Access:SOURCE (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.Access\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.Access:SOURCE(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:setAccessLevel(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.Access:SOURCE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(HeaderMap.Start)
    fsm:getState():Entry(fsm)
end

HeaderMap.StartError = HeaderMap.Default:new('HeaderMap.StartError', 11)

function HeaderMap.StartError:SOURCE (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.StartError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.StartError:SOURCE(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:setSource(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.StartError:SOURCE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(HeaderMap.Start)
    fsm:getState():Entry(fsm)
end

function HeaderMap.StartError:CLASS_NAME (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.StartError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.StartError:CLASS_NAME(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.StartError:CLASS_NAME(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(HeaderMap.Context)
    fsm:getState():Entry(fsm)
end

function HeaderMap.StartError:START_STATE (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.StartError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.StartError:START_STATE(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.StartError:START_STATE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(HeaderMap.StartState)
    fsm:getState():Entry(fsm)
end

function HeaderMap.StartError:FSM_CLASS_NAME (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.StartError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.StartError:FSM_CLASS_NAME(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.StartError:FSM_CLASS_NAME(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(HeaderMap.FsmClassName)
    fsm:getState():Entry(fsm)
end

function HeaderMap.StartError:HEADER_FILE (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.StartError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.StartError:HEADER_FILE(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.StartError:HEADER_FILE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(HeaderMap.HeaderFile)
    fsm:getState():Entry(fsm)
end

function HeaderMap.StartError:INCLUDE_FILE (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.StartError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.StartError:INCLUDE_FILE(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.StartError:INCLUDE_FILE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(HeaderMap.IncludeFile)
    fsm:getState():Entry(fsm)
end

function HeaderMap.StartError:PACKAGE_NAME (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.StartError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.StartError:PACKAGE_NAME(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.StartError:PACKAGE_NAME(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(HeaderMap.Package)
    fsm:getState():Entry(fsm)
end

function HeaderMap.StartError:IMPORT (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.StartError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.StartError:IMPORT(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.StartError:IMPORT(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(HeaderMap.Import)
    fsm:getState():Entry(fsm)
end

function HeaderMap.StartError:DECLARE (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.StartError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.StartError:DECLARE(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.StartError:DECLARE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(HeaderMap.Declare)
    fsm:getState():Entry(fsm)
end

function HeaderMap.StartError:ACCESS (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.StartError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.StartError:ACCESS(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.StartError:ACCESS(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(HeaderMap.Access)
    fsm:getState():Entry(fsm)
end

function HeaderMap.StartError:MAP_NAME (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.StartError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.StartError:MAP_NAME(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.StartError:MAP_NAME(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(HeaderMap.Start)
    fsm:getState():Entry(fsm)
    fsm:pushState(MapsMap.MapName)
    fsm:getState():Entry(fsm)
end

function HeaderMap.StartError:Default (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : HeaderMap.StartError\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: HeaderMap.StartError:Default()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: HeaderMap.StartError:Default()\n")
    end
end

MapsMap.Default = ParserState:new('MapsMap.Default', -1)

MapsMap.MapStart = MapsMap.Default:new('MapsMap.MapStart', 12)

function MapsMap.MapStart:MAP_NAME (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.MapStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.MapStart:MAP_NAME(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.MapStart:MAP_NAME(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(MapsMap.MapName)
    fsm:getState():Entry(fsm)
end

function MapsMap.MapStart:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.MapStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.MapStart:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("Expecting %map.")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.MapStart:Default()\n")
    end
    fsm:setState(MapsMap.MapStartError)
    fsm:getState():Entry(fsm)
end

MapsMap.MapStartError = MapsMap.Default:new('MapsMap.MapStartError', 13)

function MapsMap.MapStartError:MAP_NAME (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.MapStartError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.MapStartError:MAP_NAME(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.MapStartError:MAP_NAME(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(MapsMap.MapName)
    fsm:getState():Entry(fsm)
end

function MapsMap.MapStartError:Default (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.MapStartError\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.MapStartError:Default()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.MapStartError:Default()\n")
    end
end

MapsMap.MapName = MapsMap.Default:new('MapsMap.MapName', 14)

function MapsMap.MapName:WORD (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.MapName\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.MapName:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createMap(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.MapName:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(MapsMap.MapStates)
    fsm:getState():Entry(fsm)
end

function MapsMap.MapName:EOD (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.MapName\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.MapName:EOD(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:_error("Name expected after \"%map\".")
    ctxt:createMap("no_named")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.MapName:EOD(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(MapsMap.States)
    fsm:getState():Entry(fsm)
end

function MapsMap.MapName:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.MapName\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.MapName:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("Name expected after \"%map\".")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.MapName:Default()\n")
    end
    fsm:setState(endState)
end

MapsMap.MapStates = MapsMap.Default:new('MapsMap.MapStates', 15)

function MapsMap.MapStates:EOD (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.MapStates\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.MapStates:EOD(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.MapStates:EOD(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(MapsMap.States)
    fsm:getState():Entry(fsm)
end

function MapsMap.MapStates:WORD (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.MapStates\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.MapStates:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:_error("Expecting %% after \"%map mapname\".")
    ctxt:createState(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.MapStates:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(MapsMap.StateStart)
    fsm:getState():Entry(fsm)
end

function MapsMap.MapStates:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.MapStates\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.MapStates:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("Expecting %% after \"%map mapname\".")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.MapStates:Default()\n")
    end
    fsm:setState(MapsMap.MapStatesError)
    fsm:getState():Entry(fsm)
end

MapsMap.MapStatesError = MapsMap.Default:new('MapsMap.MapStatesError', 16)

function MapsMap.MapStatesError:EOD (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.MapStatesError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.MapStatesError:EOD(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.MapStatesError:EOD(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(MapsMap.States)
    fsm:getState():Entry(fsm)
end

function MapsMap.MapStatesError:MAP_NAME (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.MapStatesError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.MapStatesError:MAP_NAME(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:addMap()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.MapStatesError:MAP_NAME(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(MapsMap.MapName)
    fsm:getState():Entry(fsm)
end

function MapsMap.MapStatesError:WORD (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.MapStatesError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.MapStatesError:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createState(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.MapStatesError:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(MapsMap.StateStart)
    fsm:getState():Entry(fsm)
end

function MapsMap.MapStatesError:Default (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.MapStatesError\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.MapStatesError:Default()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.MapStatesError:Default()\n")
    end
end

MapsMap.States = MapsMap.Default:new('MapsMap.States', 17)

function MapsMap.States:EOD (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.States\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.States:EOD(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:addMap()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.States:EOD(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(MapsMap.MapStart)
    fsm:getState():Entry(fsm)
end

function MapsMap.States:WORD (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.States\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.States:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createState(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.States:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(MapsMap.StateStart)
    fsm:getState():Entry(fsm)
end

function MapsMap.States:ENTRY (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.States\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.States:ENTRY(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:_error("Expecting either a new state definition or end of map (%%).")
    ctxt:createState(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.States:ENTRY(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(MapsMap.EntryStart)
    fsm:getState():Entry(fsm)
end

function MapsMap.States:EXIT (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.States\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.States:EXIT(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:_error("Expecting either a new state definition or end of map (%%).")
    ctxt:createState(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.States:EXIT(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(MapsMap.ExitStart)
    fsm:getState():Entry(fsm)
end

function MapsMap.States:LEFT_BRACE (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.States\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.States:LEFT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:_error("Expecting either a new state definition or end of map (%%).")
    ctxt:createState(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.States:LEFT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(MapsMap.TransEnd)
    fsm:getState():Entry(fsm)
    fsm:pushState(TransitionsMap.Start)
    fsm:getState():Entry(fsm)
end

function MapsMap.States:MAP_NAME (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.States\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.States:MAP_NAME(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:_error("Expecting \"%%\" before another \"%map\".")
    ctxt:addMap()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.States:MAP_NAME(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(MapsMap.MapName)
    fsm:getState():Entry(fsm)
end

function MapsMap.States:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.States\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.States:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("Expecting either a new state definition or end of map (%%).")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.States:Default()\n")
    end
    fsm:setState(endState)
end

MapsMap.StateStart = MapsMap.Default:new('MapsMap.StateStart', 18)

function MapsMap.StateStart:ENTRY (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.StateStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.StateStart:ENTRY(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.StateStart:ENTRY(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(MapsMap.EntryStart)
    fsm:getState():Entry(fsm)
end

function MapsMap.StateStart:EXIT (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.StateStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.StateStart:EXIT(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.StateStart:EXIT(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(MapsMap.ExitStart)
    fsm:getState():Entry(fsm)
end

function MapsMap.StateStart:LEFT_BRACE (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.StateStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.StateStart:LEFT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.StateStart:LEFT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(MapsMap.TransEnd)
    fsm:getState():Entry(fsm)
    fsm:pushState(TransitionsMap.Start)
    fsm:getState():Entry(fsm)
end

function MapsMap.StateStart:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.StateStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.StateStart:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("After the state name is given, then either an entry action, exit action or opening brace is expected.")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.StateStart:Default()\n")
    end
    fsm:setState(MapsMap.StateStartError)
    fsm:getState():Entry(fsm)
end

MapsMap.StateStartError = MapsMap.Default:new('MapsMap.StateStartError', 19)

function MapsMap.StateStartError:ENTRY (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.StateStartError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.StateStartError:ENTRY(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.StateStartError:ENTRY(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(MapsMap.EntryStart)
    fsm:getState():Entry(fsm)
end

function MapsMap.StateStartError:EXIT (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.StateStartError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.StateStartError:EXIT(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.StateStartError:EXIT(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(MapsMap.ExitStart)
    fsm:getState():Entry(fsm)
end

function MapsMap.StateStartError:LEFT_BRACE (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.StateStartError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.StateStartError:LEFT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.StateStartError:LEFT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(MapsMap.TransEnd)
    fsm:getState():Entry(fsm)
    fsm:pushState(TransitionsMap.Start)
    fsm:getState():Entry(fsm)
end

function MapsMap.StateStartError:Default (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.StateStartError\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.StateStartError:Default()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.StateStartError:Default()\n")
    end
end

MapsMap.TransEnd = MapsMap.Default:new('MapsMap.TransEnd', 20)

function MapsMap.TransEnd:transitionsDone (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.TransEnd\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.TransEnd:transitionsDone()\n")
    end
    fsm:clearState()
    ctxt:addState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.TransEnd:transitionsDone()\n")
    end
    fsm:setState(MapsMap.States)
    fsm:getState():Entry(fsm)
end

MapsMap.EntryStart = MapsMap.Default:new('MapsMap.EntryStart', 21)

function MapsMap.EntryStart:LEFT_BRACE (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.EntryStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.EntryStart:LEFT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createActionList()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.EntryStart:LEFT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(MapsMap.EntryEnd)
    fsm:getState():Entry(fsm)
    fsm:pushState(ActionsMap.Start)
    fsm:getState():Entry(fsm)
end

function MapsMap.EntryStart:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.EntryStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.EntryStart:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("An opening brace is expected after Entry.")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.EntryStart:Default()\n")
    end
    fsm:setState(MapsMap.StateStartError)
    fsm:getState():Entry(fsm)
end

MapsMap.EntryEnd = MapsMap.Default:new('MapsMap.EntryEnd', 22)

function MapsMap.EntryEnd:actionsDone (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.EntryEnd\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.EntryEnd:actionsDone()\n")
    end
    fsm:clearState()
    ctxt:setEntryAction()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.EntryEnd:actionsDone()\n")
    end
    fsm:setState(MapsMap.StateStart)
    fsm:getState():Entry(fsm)
end

function MapsMap.EntryEnd:actionsError (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.EntryEnd\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.EntryEnd:actionsError()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.EntryEnd:actionsError()\n")
    end
    fsm:setState(MapsMap.MapStartError)
    fsm:getState():Entry(fsm)
end

MapsMap.ExitStart = MapsMap.Default:new('MapsMap.ExitStart', 23)

function MapsMap.ExitStart:LEFT_BRACE (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.ExitStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.ExitStart:LEFT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createActionList()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.ExitStart:LEFT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(MapsMap.ExitEnd)
    fsm:getState():Entry(fsm)
    fsm:pushState(ActionsMap.Start)
    fsm:getState():Entry(fsm)
end

function MapsMap.ExitStart:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.ExitStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.ExitStart:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("A opening brace is expected after Exit.")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.ExitStart:Default()\n")
    end
    fsm:setState(MapsMap.StateStartError)
    fsm:getState():Entry(fsm)
end

MapsMap.ExitEnd = MapsMap.Default:new('MapsMap.ExitEnd', 24)

function MapsMap.ExitEnd:actionsDone (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.ExitEnd\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.ExitEnd:actionsDone()\n")
    end
    fsm:clearState()
    ctxt:setExitAction()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.ExitEnd:actionsDone()\n")
    end
    fsm:setState(MapsMap.StateStart)
    fsm:getState():Entry(fsm)
end

function MapsMap.ExitEnd:actionsError (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : MapsMap.ExitEnd\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: MapsMap.ExitEnd:actionsError()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: MapsMap.ExitEnd:actionsError()\n")
    end
    fsm:setState(MapsMap.MapStartError)
    fsm:getState():Entry(fsm)
end

TransitionsMap.Default = ParserState:new('TransitionsMap.Default', -1)

TransitionsMap.Start = TransitionsMap.Default:new('TransitionsMap.Start', 25)

function TransitionsMap.Start:RIGHT_BRACE (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.Start:RIGHT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.Start:RIGHT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:popState()
    fsm:transitionsDone()
end

function TransitionsMap.Start:WORD (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.Start:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:storeTransitionName(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.Start:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.TransStart)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.Start:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.Start:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("Expecting either a new transition or a closing brace.")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.Start:Default()\n")
    end
    fsm:setState(TransitionsMap.TransError)
    fsm:getState():Entry(fsm)
end

TransitionsMap.TransError = TransitionsMap.Default:new('TransitionsMap.TransError', 26)

function TransitionsMap.TransError:RIGHT_BRACE (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransError:RIGHT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:addState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransError:RIGHT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:popState()
    fsm:transitionsDone()
end

function TransitionsMap.TransError:WORD (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransError:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:storeTransitionName(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransError:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.TransStart)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.TransError:Default (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransError\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransError:Default()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransError:Default()\n")
    end
end

TransitionsMap.TransStart = TransitionsMap.Default:new('TransitionsMap.TransStart', 27)

function TransitionsMap.TransStart:LEFT_PAREN (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransStart:LEFT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createParamList()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransStart:LEFT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.TransParams)
    fsm:getState():Entry(fsm)
    fsm:pushState(ParamsMap.Start)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.TransStart:LEFT_BRACKET (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransStart:LEFT_BRACKET(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createTransition()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransStart:LEFT_BRACKET(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.TransGuard)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.TransStart:PUSH (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransStart:PUSH(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createTransition()
    ctxt:createGuard()
    ctxt:setTransType("TRANS_PUSH")
    ctxt:setEndState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransStart:PUSH(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.PushStart)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.TransStart:POP (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransStart:POP(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createTransition()
    ctxt:createGuard()
    ctxt:setTransType("TRANS_POP")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransStart:POP(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.PopStart)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.TransStart:JUMP (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransStart:JUMP(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createTransition()
    ctxt:createGuard()
    ctxt:setTransType("TRANS_SET")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransStart:JUMP(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.JumpStart)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.TransStart:WORD (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransStart:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createTransition()
    ctxt:createGuard()
    ctxt:setTransType("TRANS_SET")
    ctxt:setEndState(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransStart:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.SimpleTrans)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.TransStart:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransStart:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("Expecting either a guard, \"push\", \"pop\", \"jump\" or end state.")
    ctxt:createTransition()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransStart:Default()\n")
    end
    fsm:setState(TransitionsMap.TransStartError)
    fsm:getState():Entry(fsm)
end

TransitionsMap.TransStartError = TransitionsMap.Default:new('TransitionsMap.TransStartError', 28)

function TransitionsMap.TransStartError:LEFT_PAREN (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransStartError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransStartError:LEFT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createParamList()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransStartError:LEFT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.TransParams)
    fsm:getState():Entry(fsm)
    fsm:pushState(ParamsMap.Start)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.TransStartError:LEFT_BRACKET (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransStartError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransStartError:LEFT_BRACKET(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransStartError:LEFT_BRACKET(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.TransGuard)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.TransStartError:LEFT_BRACE (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransStartError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransStartError:LEFT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createGuard()
    ctxt:setTransType("TRANS_SET")
    ctxt:setEndState()
    ctxt:createActionList()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransStartError:LEFT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.ActionEnd)
    fsm:getState():Entry(fsm)
    fsm:pushState(ActionsMap.Start)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.TransStartError:PUSH (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransStartError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransStartError:PUSH(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createGuard()
    ctxt:setTransType("TRANS_PUSH")
    ctxt:setEndState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransStartError:PUSH(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.PushStart)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.TransStartError:POP (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransStartError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransStartError:POP(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createGuard()
    ctxt:setTransType("TRANS_POP")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransStartError:POP(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.PopStart)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.TransStartError:JUMP (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransStartError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransStartError:JUMP(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createGuard()
    ctxt:setTransType("TRANS_SET")
    ctxt:setEndState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransStartError:JUMP(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.JumpStart)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.TransStartError:RIGHT_BRACE (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransStartError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransStartError:RIGHT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:addGuard()
    ctxt:addTransition()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransStartError:RIGHT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.Start)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.TransStartError:Default (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransStartError\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransStartError:Default()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransStartError:Default()\n")
    end
end

TransitionsMap.TransParams = TransitionsMap.Default:new('TransitionsMap.TransParams', 29)

function TransitionsMap.TransParams:paramsDone (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransParams\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransParams:paramsDone()\n")
    end
    fsm:clearState()
    ctxt:createTransition()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransParams:paramsDone()\n")
    end
    fsm:setState(TransitionsMap.TransNext)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.TransParams:paramsError (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransParams\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransParams:paramsError()\n")
    end
    fsm:clearState()
    ctxt:createTransition()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransParams:paramsError()\n")
    end
    fsm:setState(TransitionsMap.TransNext)
    fsm:getState():Entry(fsm)
end

TransitionsMap.TransNext = TransitionsMap.Default:new('TransitionsMap.TransNext', 30)

function TransitionsMap.TransNext:LEFT_BRACKET (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransNext\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransNext:LEFT_BRACKET(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransNext:LEFT_BRACKET(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.TransGuard)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.TransNext:PUSH (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransNext\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransNext:PUSH(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createGuard()
    ctxt:setTransType("TRANS_PUSH")
    ctxt:setEndState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransNext:PUSH(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.PushStart)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.TransNext:POP (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransNext\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransNext:POP(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createGuard()
    ctxt:setTransType("TRANS_POP")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransNext:POP(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.PopStart)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.TransNext:JUMP (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransNext\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransNext:JUMP(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createGuard()
    ctxt:setTransType("TRANS_SET")
    ctxt:setEndState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransNext:JUMP(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.JumpStart)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.TransNext:WORD (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransNext\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransNext:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createGuard()
    ctxt:setTransType("TRANS_SET")
    ctxt:setEndState(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransNext:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.SimpleTrans)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.TransNext:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransNext\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransNext:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("Expecting either a guard, \"push\", \"pop\", \"jump\" or end state.")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransNext:Default()\n")
    end
    fsm:setState(TransitionsMap.TransNextError)
    fsm:getState():Entry(fsm)
end

TransitionsMap.TransNextError = TransitionsMap.Default:new('TransitionsMap.TransNextError', 31)

function TransitionsMap.TransNextError:LEFT_PAREN (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransNextError\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransNextError:LEFT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransNextError:LEFT_PAREN(token=" .. tostring(token) .. ")\n")
    end
end

function TransitionsMap.TransNextError:LEFT_BRACKET (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransNextError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransNextError:LEFT_BRACKET(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransNextError:LEFT_BRACKET(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.TransGuard)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.TransNextError:PUSH (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransNextError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransNextError:PUSH(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createGuard()
    ctxt:setTransType("TRANS_PUSH")
    ctxt:setEndState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransNextError:PUSH(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.PushStart)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.TransNextError:POP (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransNextError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransNextError:POP(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createGuard()
    ctxt:setTransType("TRANS_POP")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransNextError:POP(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.PopStart)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.TransNextError:JUMP (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransNextError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransNextError:JUMP(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createGuard()
    ctxt:setTransType("TRANS_SET")
    ctxt:setEndState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransNextError:JUMP(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.JumpStart)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.TransNextError:WORD (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransNextError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransNextError:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createGuard()
    ctxt:setTransType("TRANS_SET")
    ctxt:setEndState(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransNextError:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.SimpleTrans)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.TransNextError:Default (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransNextError\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransNextError:Default()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransNextError:Default()\n")
    end
end

TransitionsMap.TransGuard = TransitionsMap.Default:new('TransitionsMap.TransGuard', 32)

function TransitionsMap.TransGuard:Entry (fsm)
    local ctxt = fsm:getOwner()
    ctxt:setRawMode()
end

function TransitionsMap.TransGuard:SOURCE (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.TransGuard\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.TransGuard:SOURCE(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createGuard(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.TransGuard:SOURCE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.EndState)
    fsm:getState():Entry(fsm)
end

TransitionsMap.EndState = TransitionsMap.Default:new('TransitionsMap.EndState', 33)

function TransitionsMap.EndState:PUSH (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.EndState\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.EndState:PUSH(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:setTransType("TRANS_PUSH")
    ctxt:setEndState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.EndState:PUSH(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.PushStart)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.EndState:POP (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.EndState\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.EndState:POP(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:setTransType("TRANS_POP")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.EndState:POP(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.PopStart)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.EndState:JUMP (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.EndState\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.EndState:JUMP(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:setTransType("TRANS_SET")
    ctxt:setEndState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.EndState:JUMP(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.JumpStart)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.EndState:WORD (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.EndState\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.EndState:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:setTransType("TRANS_SET")
    ctxt:setEndState(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.EndState:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.SimpleTrans)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.EndState:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.EndState\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.EndState:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("Expecting either \"push\", \"pop\", \"jump\" or end state.")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.EndState:Default()\n")
    end
    fsm:setState(TransitionsMap.EndStateError)
    fsm:getState():Entry(fsm)
end

TransitionsMap.EndStateError = TransitionsMap.Default:new('TransitionsMap.EndStateError', 34)

function TransitionsMap.EndStateError:LEFT_BRACE (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.EndStateError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.EndStateError:LEFT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createActionList()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.EndStateError:LEFT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.ActionEnd)
    fsm:getState():Entry(fsm)
    fsm:pushState(ActionsMap.Start)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.EndStateError:Default (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.EndStateError\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.EndStateError:Default()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.EndStateError:Default()\n")
    end
end

TransitionsMap.SimpleTrans = TransitionsMap.Default:new('TransitionsMap.SimpleTrans', 35)

function TransitionsMap.SimpleTrans:SLASH (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.SimpleTrans\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.SimpleTrans:SLASH(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:setTransType("TRANS_PUSH")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.SimpleTrans:SLASH(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.PushTransition)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.SimpleTrans:LEFT_BRACE (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.SimpleTrans\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.SimpleTrans:LEFT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createActionList()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.SimpleTrans:LEFT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.ActionEnd)
    fsm:getState():Entry(fsm)
    fsm:pushState(ActionsMap.Start)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.SimpleTrans:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.SimpleTrans\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.SimpleTrans:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("An opening brace must proceed any action definitions.")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.SimpleTrans:Default()\n")
    end
    fsm:setState(TransitionsMap.ActionStartError)
    fsm:getState():Entry(fsm)
end

TransitionsMap.PushTransition = TransitionsMap.Default:new('TransitionsMap.PushTransition', 36)

function TransitionsMap.PushTransition:PUSH (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.PushTransition\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.PushTransition:PUSH(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.PushTransition:PUSH(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.PushStart)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.PushTransition:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.PushTransition\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.PushTransition:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("\"push\" must follow a '/'.")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.PushTransition:Default()\n")
    end
    fsm:setState(TransitionsMap.PushError)
    fsm:getState():Entry(fsm)
end

TransitionsMap.PushStart = TransitionsMap.Default:new('TransitionsMap.PushStart', 37)

function TransitionsMap.PushStart:LEFT_PAREN (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.PushStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.PushStart:LEFT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.PushStart:LEFT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.PushMap)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.PushStart:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.PushStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.PushStart:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("\"push\" must be followed by a '/'.")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.PushStart:Default()\n")
    end
    fsm:setState(TransitionsMap.PushError)
    fsm:getState():Entry(fsm)
end

TransitionsMap.PushError = TransitionsMap.Default:new('TransitionsMap.PushError', 38)

function TransitionsMap.PushError:RIGHT_PAREN (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.PushError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.PushError:RIGHT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.PushError:RIGHT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.ActionStart)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.PushError:LEFT_BRACE (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.PushError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.PushError:LEFT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createActionList()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.PushError:LEFT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.ActionEnd)
    fsm:getState():Entry(fsm)
    fsm:pushState(ActionsMap.Start)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.PushError:Default (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.PushError\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.PushError:Default()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.PushError:Default()\n")
    end
end

TransitionsMap.PushMap = TransitionsMap.Default:new('TransitionsMap.PushMap', 39)

function TransitionsMap.PushMap:WORD (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.PushMap\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.PushMap:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:setPushState(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.PushMap:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.PushEnd)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.PushMap:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.PushMap\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.PushMap:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("Expecting a state name.")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.PushMap:Default()\n")
    end
    fsm:setState(TransitionsMap.PushError)
    fsm:getState():Entry(fsm)
end

TransitionsMap.PushEnd = TransitionsMap.Default:new('TransitionsMap.PushEnd', 40)

function TransitionsMap.PushEnd:RIGHT_PAREN (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.PushEnd\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.PushEnd:RIGHT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.PushEnd:RIGHT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.ActionStart)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.PushEnd:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.PushEnd\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.PushEnd:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("push transition missing closing paren.")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.PushEnd:Default()\n")
    end
    fsm:setState(TransitionsMap.PushError)
    fsm:getState():Entry(fsm)
end

TransitionsMap.JumpStart = TransitionsMap.Default:new('TransitionsMap.JumpStart', 41)

function TransitionsMap.JumpStart:LEFT_PAREN (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.JumpStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.JumpStart:LEFT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.JumpStart:LEFT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.JumpMap)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.JumpStart:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.JumpStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.JumpStart:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("\"jump\" must be followed by a '/'.")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.JumpStart:Default()\n")
    end
    fsm:setState(TransitionsMap.JumpError)
    fsm:getState():Entry(fsm)
end

TransitionsMap.JumpError = TransitionsMap.Default:new('TransitionsMap.JumpError', 42)

function TransitionsMap.JumpError:RIGHT_PAREN (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.JumpError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.JumpError:RIGHT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.JumpError:RIGHT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.ActionStart)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.JumpError:LEFT_BRACE (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.JumpError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.JumpError:LEFT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createActionList()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.JumpError:LEFT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.ActionEnd)
    fsm:getState():Entry(fsm)
    fsm:pushState(ActionsMap.Start)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.JumpError:Default (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.JumpError\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.JumpError:Default()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.JumpError:Default()\n")
    end
end

TransitionsMap.JumpMap = TransitionsMap.Default:new('TransitionsMap.JumpMap', 43)

function TransitionsMap.JumpMap:WORD (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.JumpMap\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.JumpMap:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:setEndState(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.JumpMap:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.JumpEnd)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.JumpMap:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.JumpMap\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.JumpMap:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("Expecting a state name.")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.JumpMap:Default()\n")
    end
    fsm:setState(TransitionsMap.JumpError)
    fsm:getState():Entry(fsm)
end

TransitionsMap.JumpEnd = TransitionsMap.Default:new('TransitionsMap.JumpEnd', 44)

function TransitionsMap.JumpEnd:RIGHT_PAREN (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.JumpEnd\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.JumpEnd:RIGHT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.JumpEnd:RIGHT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.ActionStart)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.JumpEnd:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.JumpEnd\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.JumpEnd:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("jump transition missing closing paren.")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.JumpEnd:Default()\n")
    end
    fsm:setState(TransitionsMap.JumpError)
    fsm:getState():Entry(fsm)
end

TransitionsMap.PopStart = TransitionsMap.Default:new('TransitionsMap.PopStart', 45)

function TransitionsMap.PopStart:LEFT_PAREN (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.PopStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.PopStart:LEFT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.PopStart:LEFT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.PopAction)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.PopStart:LEFT_BRACE (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.PopStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.PopStart:LEFT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createActionList()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.PopStart:LEFT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.ActionEnd)
    fsm:getState():Entry(fsm)
    fsm:pushState(ActionsMap.Start)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.PopStart:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.PopStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.PopStart:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("Expecting '(trans)' or opening brace after pop.")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.PopStart:Default()\n")
    end
    fsm:setState(TransitionsMap.PopError)
    fsm:getState():Entry(fsm)
end

TransitionsMap.PopError = TransitionsMap.Default:new('TransitionsMap.PopError', 46)

function TransitionsMap.PopError:RIGHT_PAREN (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.PopError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.PopError:RIGHT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.PopError:RIGHT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.ActionStart)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.PopError:LEFT_BRACE (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.PopError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.PopError:LEFT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createActionList()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.PopError:LEFT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.ActionEnd)
    fsm:getState():Entry(fsm)
    fsm:pushState(ActionsMap.Start)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.PopError:Default (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.PopError\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.PopError:Default()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.PopError:Default()\n")
    end
end

TransitionsMap.PopAction = TransitionsMap.Default:new('TransitionsMap.PopAction', 47)

function TransitionsMap.PopAction:RIGHT_PAREN (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.PopAction\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.PopAction:RIGHT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.PopAction:RIGHT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.ActionStart)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.PopAction:WORD (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.PopAction\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.PopAction:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:setEndState(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.PopAction:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.PopArgs)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.PopAction:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.PopAction\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.PopAction:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("Expecting either a pop transition or closing paren.")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.PopAction:Default()\n")
    end
    fsm:setState(TransitionsMap.PopError)
    fsm:getState():Entry(fsm)
end

TransitionsMap.PopArgs = TransitionsMap.Default:new('TransitionsMap.PopArgs', 48)

function TransitionsMap.PopArgs:RIGHT_PAREN (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.PopArgs\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.PopArgs:RIGHT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.PopArgs:RIGHT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.ActionStart)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.PopArgs:COMMA (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.PopArgs\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.PopArgs:COMMA(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createArgList()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.PopArgs:COMMA(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.PopArgsEnd)
    fsm:getState():Entry(fsm)
    fsm:pushState(ArgsMap.Start)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.PopArgs:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.PopArgs\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.PopArgs:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("Pop transition missing closing paren.")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.PopArgs:Default()\n")
    end
    fsm:setState(TransitionsMap.PopError)
    fsm:getState():Entry(fsm)
end

TransitionsMap.PopArgsEnd = TransitionsMap.Default:new('TransitionsMap.PopArgsEnd', 49)

function TransitionsMap.PopArgsEnd:argsDone (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.PopArgsEnd\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.PopArgsEnd:argsDone()\n")
    end
    fsm:clearState()
    ctxt:setPopArgs()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.PopArgsEnd:argsDone()\n")
    end
    fsm:setState(TransitionsMap.ActionStart)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.PopArgsEnd:argsError (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.PopArgsEnd\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.PopArgsEnd:argsError()\n")
    end
    fsm:clearState()
    ctxt:_error("Pop transition missing closing paren.")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.PopArgsEnd:argsError()\n")
    end
    fsm:setState(TransitionsMap.PopError)
    fsm:getState():Entry(fsm)
end

TransitionsMap.ActionStart = TransitionsMap.Default:new('TransitionsMap.ActionStart', 50)

function TransitionsMap.ActionStart:LEFT_BRACE (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.ActionStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.ActionStart:LEFT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createActionList()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.ActionStart:LEFT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.ActionEnd)
    fsm:getState():Entry(fsm)
    fsm:pushState(ActionsMap.Start)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.ActionStart:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.ActionStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.ActionStart:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("An opening brace must proceed any action definitions.")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.ActionStart:Default()\n")
    end
    fsm:setState(TransitionsMap.ActionStartError)
    fsm:getState():Entry(fsm)
end

TransitionsMap.ActionEnd = TransitionsMap.Default:new('TransitionsMap.ActionEnd', 51)

function TransitionsMap.ActionEnd:actionsDone (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.ActionEnd\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.ActionEnd:actionsDone()\n")
    end
    fsm:clearState()
    ctxt:setActions()
    ctxt:addGuard()
    ctxt:addTransition()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.ActionEnd:actionsDone()\n")
    end
    fsm:setState(TransitionsMap.Start)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.ActionEnd:actionsError (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.ActionEnd\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.ActionEnd:actionsError()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.ActionEnd:actionsError()\n")
    end
    fsm:setState(TransitionsMap.Start)
    fsm:getState():Entry(fsm)
end

TransitionsMap.ActionStartError = TransitionsMap.Default:new('TransitionsMap.ActionStartError', 52)

function TransitionsMap.ActionStartError:LEFT_BRACE (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.ActionStartError\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.ActionStartError:LEFT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createActionList()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.ActionStartError:LEFT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(TransitionsMap.ActionEnd)
    fsm:getState():Entry(fsm)
    fsm:pushState(ActionsMap.Start)
    fsm:getState():Entry(fsm)
end

function TransitionsMap.ActionStartError:Default (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TransitionsMap.ActionStartError\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TransitionsMap.ActionStartError:Default()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TransitionsMap.ActionStartError:Default()\n")
    end
end

ParamsMap.Default = ParserState:new('ParamsMap.Default', -1)

ParamsMap.Start = ParamsMap.Default:new('ParamsMap.Start', 53)

function ParamsMap.Start:WORD (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ParamsMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ParamsMap.Start:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createParameter(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ParamsMap.Start:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(ParamsMap.ParamSeparator)
    fsm:getState():Entry(fsm)
end

function ParamsMap.Start:RIGHT_PAREN (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ParamsMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ParamsMap.Start:RIGHT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ParamsMap.Start:RIGHT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    fsm:popState()
    fsm:paramsDone()
end

function ParamsMap.Start:DOLLAR (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ParamsMap.Start\n")
    end
    if ctxt.targetLanguage == 'PERL'
    or ctxt.targetLanguage == 'PHP'
    or ctxt.targetLanguage == 'GRAPH'
    or ctxt.targetLanguage == 'TABLE' then
        fsm:getState():Exit(fsm)
        if fsm:getDebugFlag() then
            fsm:getDebugStream():write("ENTER TRANSITION: ParamsMap.Start:DOLLAR(token=" .. tostring(token) .. ")\n")
        end
        -- No actions.
        if fsm:getDebugFlag() then
            fsm:getDebugStream():write("EXIT TRANSITION: ParamsMap.Start:DOLLAR(token=" .. tostring(token) .. ")\n")
        end
        fsm:setState(ParamsMap.Dollar)
        fsm:getState():Entry(fsm)
    else
        ParamsMap.Default:DOLLAR(fsm, token)
    end
end

function ParamsMap.Start:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ParamsMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ParamsMap.Start:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("Invalid parameter syntax.")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ParamsMap.Start:Default()\n")
    end
    fsm:setState(ParamsMap.Error)
    fsm:getState():Entry(fsm)
end

ParamsMap.Dollar = ParamsMap.Default:new('ParamsMap.Dollar', 54)

function ParamsMap.Dollar:WORD (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ParamsMap.Dollar\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ParamsMap.Dollar:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createParameter(token, "$")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ParamsMap.Dollar:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(ParamsMap.ParamSeparator)
    fsm:getState():Entry(fsm)
end

function ParamsMap.Dollar:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ParamsMap.Dollar\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ParamsMap.Dollar:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("Invalid parameter syntax.")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ParamsMap.Dollar:Default()\n")
    end
    fsm:setState(ParamsMap.Error)
    fsm:getState():Entry(fsm)
end

ParamsMap.ParamSeparator = ParamsMap.Default:new('ParamsMap.ParamSeparator', 55)

function ParamsMap.ParamSeparator:COLON (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ParamsMap.ParamSeparator\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ParamsMap.ParamSeparator:COLON(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ParamsMap.ParamSeparator:COLON(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(ParamsMap.ParamType)
    fsm:getState():Entry(fsm)
end

function ParamsMap.ParamSeparator:COMMA (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ParamsMap.ParamSeparator\n")
    end
    if ctxt.targetLanguage == 'TCL'
    or ctxt.targetLanguage == 'GROOVY'
    or ctxt.targetLanguage == 'LUA'
    or ctxt.targetLanguage == 'PERL'
    or ctxt.targetLanguage == 'PHP'
    or ctxt.targetLanguage == 'PYTHON'
    or ctxt.targetLanguage == 'RUBY'
    or ctxt.targetLanguage == 'GRAPH'
    or ctxt.targetLanguage == 'TABLE' then
        fsm:getState():Exit(fsm)
        if fsm:getDebugFlag() then
            fsm:getDebugStream():write("ENTER TRANSITION: ParamsMap.ParamSeparator:COMMA(token=" .. tostring(token) .. ")\n")
        end
        fsm:clearState()
        ctxt:addParameter()
        if fsm:getDebugFlag() then
            fsm:getDebugStream():write("EXIT TRANSITION: ParamsMap.ParamSeparator:COMMA(token=" .. tostring(token) .. ")\n")
        end
        fsm:setState(ParamsMap.Start)
        fsm:getState():Entry(fsm)
    else
        fsm:getState():Exit(fsm)
        if fsm:getDebugFlag() then
            fsm:getDebugStream():write("ENTER TRANSITION: ParamsMap.ParamSeparator:COMMA(token=" .. tostring(token) .. ")\n")
        end
        fsm:clearState()
        ctxt:_error("Parameter type missing.")
        if fsm:getDebugFlag() then
            fsm:getDebugStream():write("EXIT TRANSITION: ParamsMap.ParamSeparator:COMMA(token=" .. tostring(token) .. ")\n")
        end
        fsm:setState(ParamsMap.Error)
        fsm:getState():Entry(fsm)
    end
end

function ParamsMap.ParamSeparator:RIGHT_PAREN (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ParamsMap.ParamSeparator\n")
    end
    if ctxt.targetLanguage == 'TCL'
    or ctxt.targetLanguage == 'GROOVY'
    or ctxt.targetLanguage == 'LUA'
    or ctxt.targetLanguage == 'PERL'
    or ctxt.targetLanguage == 'PHP'
    or ctxt.targetLanguage == 'PYTHON'
    or ctxt.targetLanguage == 'RUBY'
    or ctxt.targetLanguage == 'GRAPH'
    or ctxt.targetLanguage == 'TABLE' then
        fsm:getState():Exit(fsm)
        if fsm:getDebugFlag() then
            fsm:getDebugStream():write("ENTER TRANSITION: ParamsMap.ParamSeparator:RIGHT_PAREN(token=" .. tostring(token) .. ")\n")
        end
        fsm:clearState()
        ctxt:addParameter()
        if fsm:getDebugFlag() then
            fsm:getDebugStream():write("EXIT TRANSITION: ParamsMap.ParamSeparator:RIGHT_PAREN(token=" .. tostring(token) .. ")\n")
        end
        fsm:popState()
        fsm:paramsDone()
    else
        fsm:getState():Exit(fsm)
        if fsm:getDebugFlag() then
            fsm:getDebugStream():write("ENTER TRANSITION: ParamsMap.ParamSeparator:RIGHT_PAREN(token=" .. tostring(token) .. ")\n")
        end
        fsm:clearState()
        ctxt:_error("Parameter type missing.")
        if fsm:getDebugFlag() then
            fsm:getDebugStream():write("EXIT TRANSITION: ParamsMap.ParamSeparator:RIGHT_PAREN(token=" .. tostring(token) .. ")\n")
        end
        fsm:popState()
        fsm:paramsError()
    end
end

function ParamsMap.ParamSeparator:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ParamsMap.ParamSeparator\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ParamsMap.ParamSeparator:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("Invalid parameter syntax.")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ParamsMap.ParamSeparator:Default()\n")
    end
    fsm:setState(ParamsMap.Error)
    fsm:getState():Entry(fsm)
end

ParamsMap.ParamType = ParamsMap.Default:new('ParamsMap.ParamType', 56)

function ParamsMap.ParamType:Entry (fsm)
    local ctxt = fsm:getOwner()
    ctxt:setRawMode2()
end

function ParamsMap.ParamType:SOURCE (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ParamsMap.ParamType\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ParamsMap.ParamType:SOURCE(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:setParamType(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ParamsMap.ParamType:SOURCE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(ParamsMap.NextParam)
    fsm:getState():Entry(fsm)
end

ParamsMap.NextParam = ParamsMap.Default:new('ParamsMap.NextParam', 57)

function ParamsMap.NextParam:COMMA (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ParamsMap.NextParam\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ParamsMap.NextParam:COMMA(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:addParameter()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ParamsMap.NextParam:COMMA(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(ParamsMap.Start)
    fsm:getState():Entry(fsm)
end

function ParamsMap.NextParam:RIGHT_PAREN (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ParamsMap.NextParam\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ParamsMap.NextParam:RIGHT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:addParameter()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ParamsMap.NextParam:RIGHT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    fsm:popState()
    fsm:paramsDone()
end

function ParamsMap.NextParam:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ParamsMap.NextParam\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ParamsMap.NextParam:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("Invalid parameter syntax.")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ParamsMap.NextParam:Default()\n")
    end
    fsm:setState(ParamsMap.Error)
    fsm:getState():Entry(fsm)
end

ParamsMap.Error = ParamsMap.Default:new('ParamsMap.Error', 58)

function ParamsMap.Error:Entry (fsm)
    local ctxt = fsm:getOwner()
    ctxt:setRawMode2()
end

function ParamsMap.Error:SOURCE (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ParamsMap.Error\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ParamsMap.Error:SOURCE(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:clearParameter()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ParamsMap.Error:SOURCE(token=" .. tostring(token) .. ")\n")
    end
    fsm:popState()
    fsm:paramsError()
end

ActionsMap.Default = ParserState:new('ActionsMap.Default', -1)

ActionsMap.Start = ActionsMap.Default:new('ActionsMap.Start', 59)

function ActionsMap.Start:WORD (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ActionsMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ActionsMap.Start:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createAction(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ActionsMap.Start:WORD(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(ActionsMap.Name)
    fsm:getState():Entry(fsm)
end

function ActionsMap.Start:RIGHT_BRACE (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ActionsMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ActionsMap.Start:RIGHT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ActionsMap.Start:RIGHT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:popState()
    fsm:actionsDone()
end

function ActionsMap.Start:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ActionsMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ActionsMap.Start:Default()\n")
    end
    fsm:clearState()
    ctxt:clearActions()
    ctxt:_error("Expecting either a method name or a closing brace")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ActionsMap.Start:Default()\n")
    end
    fsm:setState(ActionsMap.Error)
    fsm:getState():Entry(fsm)
end

ActionsMap.Name = ActionsMap.Default:new('ActionsMap.Name', 60)

function ActionsMap.Name:LEFT_PAREN (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ActionsMap.Name\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ActionsMap.Name:LEFT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createArgList()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ActionsMap.Name:LEFT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(ActionsMap.Args)
    fsm:getState():Entry(fsm)
    fsm:pushState(ArgsMap.Start)
    fsm:getState():Entry(fsm)
end

function ActionsMap.Name:EQUAL (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ActionsMap.Name\n")
    end
    if ctxt.targetLanguage == 'C_SHARP'
    or ctxt.targetLanguage == 'GRAPH'
    or ctxt.targetLanguage == 'GROOVY'
    or ctxt.targetLanguage == 'LUA'
    or ctxt.targetLanguage == 'SCALA'
    or ctxt.targetLanguage == 'TABLE'
    or ctxt.targetLanguage == 'VB' then
        fsm:getState():Exit(fsm)
        if fsm:getDebugFlag() then
            fsm:getDebugStream():write("ENTER TRANSITION: ActionsMap.Name:EQUAL(token=" .. tostring(token) .. ")\n")
        end
        fsm:clearState()
        ctxt:setProperty()
        ctxt:createArgList()
        if fsm:getDebugFlag() then
            fsm:getDebugStream():write("EXIT TRANSITION: ActionsMap.Name:EQUAL(token=" .. tostring(token) .. ")\n")
        end
        fsm:setState(ActionsMap.PropertyAssignment)
        fsm:getState():Entry(fsm)
    else
        fsm:getState():Exit(fsm)
        if fsm:getDebugFlag() then
            fsm:getDebugStream():write("ENTER TRANSITION: ActionsMap.Name:EQUAL(token=" .. tostring(token) .. ")\n")
        end
        fsm:clearState()
        ctxt:clearActions()
        ctxt:_error("'=' property assignment may only be used with -csharp, -groovy, -lua, -scala or -vb")
        if fsm:getDebugFlag() then
            fsm:getDebugStream():write("EXIT TRANSITION: ActionsMap.Name:EQUAL(token=" .. tostring(token) .. ")\n")
        end
        fsm:setState(ActionsMap.Error)
        fsm:getState():Entry(fsm)
    end
end

function ActionsMap.Name:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ActionsMap.Name\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ActionsMap.Name:Default()\n")
    end
    fsm:clearState()
    ctxt:clearActions()
    ctxt:_error("Expecting an open paren after the method name")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ActionsMap.Name:Default()\n")
    end
    fsm:setState(ActionsMap.Error)
    fsm:getState():Entry(fsm)
end

ActionsMap.Args = ActionsMap.Default:new('ActionsMap.Args', 61)

function ActionsMap.Args:argsDone (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ActionsMap.Args\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ActionsMap.Args:argsDone()\n")
    end
    fsm:clearState()
    ctxt:setActionArgs()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ActionsMap.Args:argsDone()\n")
    end
    fsm:setState(ActionsMap.End)
    fsm:getState():Entry(fsm)
end

function ActionsMap.Args:argsError (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ActionsMap.Args\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ActionsMap.Args:argsError()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ActionsMap.Args:argsError()\n")
    end
    fsm:setState(ActionsMap.Error)
    fsm:getState():Entry(fsm)
end

ActionsMap.End = ActionsMap.Default:new('ActionsMap.End', 62)

function ActionsMap.End:SEMICOLON (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ActionsMap.End\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ActionsMap.End:SEMICOLON(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:addAction()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ActionsMap.End:SEMICOLON(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(ActionsMap.Start)
    fsm:getState():Entry(fsm)
end

function ActionsMap.End:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ActionsMap.End\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ActionsMap.End:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("Expecting a ';' after closing paren")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ActionsMap.End:Default()\n")
    end
    fsm:setState(ActionsMap.Error)
    fsm:getState():Entry(fsm)
end

ActionsMap.PropertyAssignment = ActionsMap.Default:new('ActionsMap.PropertyAssignment', 63)

function ActionsMap.PropertyAssignment:Entry (fsm)
    local ctxt = fsm:getOwner()
    ctxt:setRawMode3()
end

function ActionsMap.PropertyAssignment:SOURCE (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ActionsMap.PropertyAssignment\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ActionsMap.PropertyAssignment:SOURCE(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createArgument(token)
    ctxt:addArgument()
    ctxt:setActionArgs()
    ctxt:addAction()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ActionsMap.PropertyAssignment:SOURCE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(ActionsMap.Start)
    fsm:getState():Entry(fsm)
end

ActionsMap.Error = ActionsMap.Default:new('ActionsMap.Error', 64)

function ActionsMap.Error:RIGHT_BRACE (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ActionsMap.Error\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ActionsMap.Error:RIGHT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ActionsMap.Error:RIGHT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:popState()
    fsm:actionsError()
end

function ActionsMap.Error:Default (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ActionsMap.Error\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ActionsMap.Error:Default()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ActionsMap.Error:Default()\n")
    end
end

ArgsMap.Default = ParserState:new('ArgsMap.Default', -1)

ArgsMap.Start = ArgsMap.Default:new('ArgsMap.Start', 65)

function ArgsMap.Start:Entry (fsm)
    local ctxt = fsm:getOwner()
    ctxt:setRawMode2()
end

function ArgsMap.Start:SOURCE (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ArgsMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ArgsMap.Start:SOURCE(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:createArgument(token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ArgsMap.Start:SOURCE(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(ArgsMap.NextArg)
    fsm:getState():Entry(fsm)
end

ArgsMap.NextArg = ArgsMap.Default:new('ArgsMap.NextArg', 66)

function ArgsMap.NextArg:COMMA (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ArgsMap.NextArg\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ArgsMap.NextArg:COMMA(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:addArgument()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ArgsMap.NextArg:COMMA(token=" .. tostring(token) .. ")\n")
    end
    fsm:setState(ArgsMap.Start)
    fsm:getState():Entry(fsm)
end

function ArgsMap.NextArg:RIGHT_PAREN (fsm, token)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ArgsMap.NextArg\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ArgsMap.NextArg:RIGHT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    fsm:clearState()
    ctxt:addArgument()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ArgsMap.NextArg:RIGHT_PAREN(token=" .. tostring(token) .. ")\n")
    end
    fsm:popState()
    fsm:argsDone()
end

function ArgsMap.NextArg:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ArgsMap.NextArg\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ArgsMap.NextArg:Default()\n")
    end
    fsm:clearState()
    ctxt:_error("Missing ',' or closing paren after argument.")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ArgsMap.NextArg:Default()\n")
    end
    fsm:setState(ArgsMap.Error)
    fsm:getState():Entry(fsm)
end

ArgsMap.Error = ArgsMap.Default:new('ArgsMap.Error', 67)

function ArgsMap.Error:RIGHT_BRACE (fsm, token)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ArgsMap.Error\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ArgsMap.Error:RIGHT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ArgsMap.Error:RIGHT_BRACE(token=" .. tostring(token) .. ")\n")
    end
    fsm:popState()
    fsm:argsError()
end

function ArgsMap.Error:Default (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ArgsMap.Error\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ArgsMap.Error:Default()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ArgsMap.Error:Default()\n")
    end
end

ParserContext = statemap.FSMContext:class()

function ParserContext:_init ()
    self:setState(HeaderMap.Start)
end

function ParserContext:CLASS_NAME (...)
    self._transition = 'CLASS_NAME'
    self:getState():CLASS_NAME(self, ...)
    self._transition = nil
end

function ParserContext:POP (...)
    self._transition = 'POP'
    self:getState():POP(self, ...)
    self._transition = nil
end

function ParserContext:EXIT (...)
    self._transition = 'EXIT'
    self:getState():EXIT(self, ...)
    self._transition = nil
end

function ParserContext:DOLLAR (...)
    self._transition = 'DOLLAR'
    self:getState():DOLLAR(self, ...)
    self._transition = nil
end

function ParserContext:SEMICOLON (...)
    self._transition = 'SEMICOLON'
    self:getState():SEMICOLON(self, ...)
    self._transition = nil
end

function ParserContext:RIGHT_PAREN (...)
    self._transition = 'RIGHT_PAREN'
    self:getState():RIGHT_PAREN(self, ...)
    self._transition = nil
end

function ParserContext:MAP_NAME (...)
    self._transition = 'MAP_NAME'
    self:getState():MAP_NAME(self, ...)
    self._transition = nil
end

function ParserContext:SOURCE (...)
    self._transition = 'SOURCE'
    self:getState():SOURCE(self, ...)
    self._transition = nil
end

function ParserContext:FSM_CLASS_NAME (...)
    self._transition = 'FSM_CLASS_NAME'
    self:getState():FSM_CLASS_NAME(self, ...)
    self._transition = nil
end

function ParserContext:argsDone ()
    self._transition = 'argsDone'
    self:getState():argsDone(self)
    self._transition = nil
end

function ParserContext:transitionsDone ()
    self._transition = 'transitionsDone'
    self:getState():transitionsDone(self)
    self._transition = nil
end

function ParserContext:argsError ()
    self._transition = 'argsError'
    self:getState():argsError(self)
    self._transition = nil
end

function ParserContext:actionsDone ()
    self._transition = 'actionsDone'
    self:getState():actionsDone(self)
    self._transition = nil
end

function ParserContext:EQUAL (...)
    self._transition = 'EQUAL'
    self:getState():EQUAL(self, ...)
    self._transition = nil
end

function ParserContext:EOD (...)
    self._transition = 'EOD'
    self:getState():EOD(self, ...)
    self._transition = nil
end

function ParserContext:COLON (...)
    self._transition = 'COLON'
    self:getState():COLON(self, ...)
    self._transition = nil
end

function ParserContext:RIGHT_BRACE (...)
    self._transition = 'RIGHT_BRACE'
    self:getState():RIGHT_BRACE(self, ...)
    self._transition = nil
end

function ParserContext:IMPORT (...)
    self._transition = 'IMPORT'
    self:getState():IMPORT(self, ...)
    self._transition = nil
end

function ParserContext:COMMA (...)
    self._transition = 'COMMA'
    self:getState():COMMA(self, ...)
    self._transition = nil
end

function ParserContext:WORD (...)
    self._transition = 'WORD'
    self:getState():WORD(self, ...)
    self._transition = nil
end

function ParserContext:PACKAGE_NAME (...)
    self._transition = 'PACKAGE_NAME'
    self:getState():PACKAGE_NAME(self, ...)
    self._transition = nil
end

function ParserContext:DECLARE (...)
    self._transition = 'DECLARE'
    self:getState():DECLARE(self, ...)
    self._transition = nil
end

function ParserContext:ENTRY (...)
    self._transition = 'ENTRY'
    self:getState():ENTRY(self, ...)
    self._transition = nil
end

function ParserContext:actionsError ()
    self._transition = 'actionsError'
    self:getState():actionsError(self)
    self._transition = nil
end

function ParserContext:LEFT_BRACKET (...)
    self._transition = 'LEFT_BRACKET'
    self:getState():LEFT_BRACKET(self, ...)
    self._transition = nil
end

function ParserContext:LEFT_BRACE (...)
    self._transition = 'LEFT_BRACE'
    self:getState():LEFT_BRACE(self, ...)
    self._transition = nil
end

function ParserContext:paramsError ()
    self._transition = 'paramsError'
    self:getState():paramsError(self)
    self._transition = nil
end

function ParserContext:PUSH (...)
    self._transition = 'PUSH'
    self:getState():PUSH(self, ...)
    self._transition = nil
end

function ParserContext:JUMP (...)
    self._transition = 'JUMP'
    self:getState():JUMP(self, ...)
    self._transition = nil
end

function ParserContext:INCLUDE_FILE (...)
    self._transition = 'INCLUDE_FILE'
    self:getState():INCLUDE_FILE(self, ...)
    self._transition = nil
end

function ParserContext:HEADER_FILE (...)
    self._transition = 'HEADER_FILE'
    self:getState():HEADER_FILE(self, ...)
    self._transition = nil
end

function ParserContext:paramsDone ()
    self._transition = 'paramsDone'
    self:getState():paramsDone(self)
    self._transition = nil
end

function ParserContext:LEFT_PAREN (...)
    self._transition = 'LEFT_PAREN'
    self:getState():LEFT_PAREN(self, ...)
    self._transition = nil
end

function ParserContext:SLASH (...)
    self._transition = 'SLASH'
    self:getState():SLASH(self, ...)
    self._transition = nil
end

function ParserContext:ACCESS (...)
    self._transition = 'ACCESS'
    self:getState():ACCESS(self, ...)
    self._transition = nil
end

function ParserContext:START_STATE (...)
    self._transition = 'START_STATE'
    self:getState():START_STATE(self, ...)
    self._transition = nil
end

function ParserContext:enterStartState ()
    self:getState():Entry(self)
end

function ParserContext:getOwner ()
    return self._owner
end

-- Local variables:
--  buffer-read-only: t
-- End:
