-- ex: set ro:
-- DO NOT EDIT.
-- from file : src/Smc/Parser/Lexer.sm

local error = error
local tostring = tostring
local strformat = require 'string'.format

local statemap = require 'statemap'

module(...)

local LexerState = statemap.State:class()

function LexerState:Entry (fsm) end

function LexerState:Exit (fsm) end

function LexerState:left_paren (fsm)
    self:Default(fsm)
end

function LexerState:left_bracket (fsm)
    self:Default(fsm)
end

function LexerState:left_brace (fsm)
    self:Default(fsm)
end

function LexerState:digit (fsm)
    self:Default(fsm)
end

function LexerState:asterisk (fsm)
    self:Default(fsm)
end

function LexerState:period (fsm)
    self:Default(fsm)
end

function LexerState:underscore (fsm)
    self:Default(fsm)
end

function LexerState:double_quote (fsm)
    self:Default(fsm)
end

function LexerState:back_slash (fsm)
    self:Default(fsm)
end

function LexerState:raw3 (fsm)
    self:Default(fsm)
end

function LexerState:slash (fsm)
    self:Default(fsm)
end

function LexerState:dollar (fsm)
    self:Default(fsm)
end

function LexerState:commentDone (fsm)
    self:Default(fsm)
end

function LexerState:EOL (fsm)
    self:Default(fsm)
end

function LexerState:percent (fsm)
    self:Default(fsm)
end

function LexerState:raw2 (fsm)
    self:Default(fsm)
end

function LexerState:right_paren (fsm)
    self:Default(fsm)
end

function LexerState:right_brace (fsm)
    self:Default(fsm)
end

function LexerState:single_quote (fsm)
    self:Default(fsm)
end

function LexerState:guardDone (fsm)
    self:Default(fsm)
end

function LexerState:stringDone (fsm)
    self:Default(fsm)
end

function LexerState:raw1 (fsm)
    self:Default(fsm)
end

function LexerState:sourceDone (fsm)
    self:Default(fsm)
end

function LexerState:alpha (fsm)
    self:Default(fsm)
end

function LexerState:colon (fsm)
    self:Default(fsm)
end

function LexerState:semicolon (fsm)
    self:Default(fsm)
end

function LexerState:comma (fsm)
    self:Default(fsm)
end

function LexerState:unicode (fsm)
    self:Default(fsm)
end

function LexerState:right_bracket (fsm)
    self:Default(fsm)
end

function LexerState:equal (fsm)
    self:Default(fsm)
end

function LexerState:whitespace (fsm)
    self:Default(fsm)
end

function LexerState:paramDone (fsm)
    self:Default(fsm)
end

function LexerState:Default (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("TRANSITION   : Default\n")
    end
    local msg = strformat("Undefined Transition\nState: %s\nTransition: %s\n",
                          fsm:getState():getName(),
                          fsm:getTransition())
    error(msg)
end

local TokenMap = {}
local SourceMap = {}
local GuardMap = {}
local ParamTypeMap = {}
local StringDoubleMap = {}
local StringSingleMap = {}
local NewCommentMap = {}
local OldCommentMap = {}

TokenMap.Default = LexerState:new('TokenMap.Default', -1)

TokenMap.Start = TokenMap.Default:new('TokenMap.Start', 1)

function TokenMap.Start:raw1 (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Start:raw1()\n")
    end
    fsm:clearState()
    ctxt:startToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Start:raw1()\n")
    end
    fsm:setState(endState)
    fsm:pushState(GuardMap.Start)
    fsm:getState():Entry(fsm)
end

function TokenMap.Start:guardDone (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Start:guardDone()\n")
    end
    fsm:clearState()
    ctxt:endToken('SOURCE')
    ctxt:trimToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Start:guardDone()\n")
    end
    fsm:setState(endState)
end

function TokenMap.Start:raw2 (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Start:raw2()\n")
    end
    fsm:clearState()
    ctxt:startToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Start:raw2()\n")
    end
    fsm:setState(endState)
    fsm:pushState(ParamTypeMap.Start)
    fsm:getState():Entry(fsm)
end

function TokenMap.Start:paramDone (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Start:paramDone()\n")
    end
    fsm:clearState()
    ctxt:ungetChar()
    ctxt:endToken('SOURCE')
    ctxt:trimToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Start:paramDone()\n")
    end
    fsm:setState(endState)
end

function TokenMap.Start:raw3 (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Start:raw3()\n")
    end
    fsm:clearState()
    ctxt:startToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Start:raw3()\n")
    end
    fsm:setState(TokenMap.RawMode3)
    fsm:getState():Entry(fsm)
end

function TokenMap.Start:slash (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Start:slash()\n")
    end
    fsm:clearState()
    ctxt:startToken()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Start:slash()\n")
    end
    fsm:setState(TokenMap.CommentStart)
    fsm:getState():Entry(fsm)
end

function TokenMap.Start:percent (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Start:percent()\n")
    end
    fsm:clearState()
    ctxt:startToken()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Start:percent()\n")
    end
    fsm:setState(TokenMap.PercentStart)
    fsm:getState():Entry(fsm)
end

function TokenMap.Start:alpha (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Start:alpha()\n")
    end
    fsm:clearState()
    ctxt:startToken()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Start:alpha()\n")
    end
    fsm:setState(TokenMap.Word)
    fsm:getState():Entry(fsm)
end

function TokenMap.Start:underscore (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Start:underscore()\n")
    end
    fsm:clearState()
    ctxt:startToken()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Start:underscore()\n")
    end
    fsm:setState(TokenMap.Word)
    fsm:getState():Entry(fsm)
end

function TokenMap.Start:colon (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Start:colon()\n")
    end
    fsm:clearState()
    ctxt:startToken()
    ctxt:addToToken()
    ctxt:endToken('COLON')
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Start:colon()\n")
    end
    fsm:setState(endState)
end

function TokenMap.Start:left_brace (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Start:left_brace()\n")
    end
    fsm:clearState()
    ctxt:startToken()
    ctxt:addToToken()
    ctxt:endToken('LEFT_BRACE')
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Start:left_brace()\n")
    end
    fsm:setState(endState)
end

function TokenMap.Start:right_brace (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Start:right_brace()\n")
    end
    fsm:clearState()
    ctxt:startToken()
    ctxt:addToToken()
    ctxt:endToken('RIGHT_BRACE')
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Start:right_brace()\n")
    end
    fsm:setState(endState)
end

function TokenMap.Start:left_bracket (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Start:left_bracket()\n")
    end
    fsm:clearState()
    ctxt:startToken()
    ctxt:addToToken()
    ctxt:endToken('LEFT_BRACKET')
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Start:left_bracket()\n")
    end
    fsm:setState(endState)
end

function TokenMap.Start:left_paren (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Start:left_paren()\n")
    end
    fsm:clearState()
    ctxt:startToken()
    ctxt:addToToken()
    ctxt:endToken('LEFT_PAREN')
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Start:left_paren()\n")
    end
    fsm:setState(endState)
end

function TokenMap.Start:right_paren (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Start:right_paren()\n")
    end
    fsm:clearState()
    ctxt:startToken()
    ctxt:addToToken()
    ctxt:endToken('RIGHT_PAREN')
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Start:right_paren()\n")
    end
    fsm:setState(endState)
end

function TokenMap.Start:comma (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Start:comma()\n")
    end
    fsm:clearState()
    ctxt:startToken()
    ctxt:addToToken()
    ctxt:endToken('COMMA')
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Start:comma()\n")
    end
    fsm:setState(endState)
end

function TokenMap.Start:semicolon (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Start:semicolon()\n")
    end
    fsm:clearState()
    ctxt:startToken()
    ctxt:addToToken()
    ctxt:endToken('SEMICOLON')
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Start:semicolon()\n")
    end
    fsm:setState(endState)
end

function TokenMap.Start:equal (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Start:equal()\n")
    end
    fsm:clearState()
    ctxt:startToken()
    ctxt:addToToken()
    ctxt:endToken('EQUAL')
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Start:equal()\n")
    end
    fsm:setState(endState)
end

function TokenMap.Start:dollar (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Start:dollar()\n")
    end
    fsm:clearState()
    ctxt:startToken()
    ctxt:addToToken()
    ctxt:endToken('DOLLAR')
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Start:dollar()\n")
    end
    fsm:setState(endState)
end

function TokenMap.Start:whitespace (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Start\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Start:whitespace()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Start:whitespace()\n")
    end
end

function TokenMap.Start:EOL (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Start\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Start:EOL()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Start:EOL()\n")
    end
end

function TokenMap.Start:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Start:Default()\n")
    end
    fsm:clearState()
    ctxt:startToken()
    ctxt:addToToken()
    ctxt:badToken("Unknown token")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Start:Default()\n")
    end
    fsm:setState(endState)
end

TokenMap.RawMode3 = TokenMap.Default:new('TokenMap.RawMode3', 2)

function TokenMap.RawMode3:EOL (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.RawMode3\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.RawMode3:EOL()\n")
    end
    fsm:clearState()
    ctxt:endToken('SOURCE')
    ctxt:trimToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.RawMode3:EOL()\n")
    end
    fsm:setState(TokenMap.Start)
    fsm:getState():Entry(fsm)
end

function TokenMap.RawMode3:semicolon (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.RawMode3\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.RawMode3:semicolon()\n")
    end
    fsm:clearState()
    ctxt:endToken('SOURCE')
    ctxt:trimToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.RawMode3:semicolon()\n")
    end
    fsm:setState(TokenMap.Start)
    fsm:getState():Entry(fsm)
end

function TokenMap.RawMode3:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.RawMode3\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.RawMode3:Default()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.RawMode3:Default()\n")
    end
    fsm:setState(endState)
end

TokenMap.CommentStart = TokenMap.Default:new('TokenMap.CommentStart', 3)

function TokenMap.CommentStart:asterisk (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.CommentStart\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.CommentStart:asterisk()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.CommentStart:asterisk()\n")
    end
    fsm:pushState(OldCommentMap.Start)
    fsm:getState():Entry(fsm)
end

function TokenMap.CommentStart:slash (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.CommentStart\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.CommentStart:slash()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.CommentStart:slash()\n")
    end
    fsm:pushState(NewCommentMap.Start)
    fsm:getState():Entry(fsm)
end

function TokenMap.CommentStart:commentDone (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.CommentStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.CommentStart:commentDone()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.CommentStart:commentDone()\n")
    end
    fsm:setState(TokenMap.Start)
    fsm:getState():Entry(fsm)
end

function TokenMap.CommentStart:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.CommentStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.CommentStart:Default()\n")
    end
    fsm:clearState()
    ctxt:ungetChar()
    ctxt:endToken('SLASH')
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.CommentStart:Default()\n")
    end
    fsm:setState(TokenMap.Start)
    fsm:getState():Entry(fsm)
end

TokenMap.PercentStart = TokenMap.Default:new('TokenMap.PercentStart', 4)

function TokenMap.PercentStart:left_brace (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.PercentStart\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.PercentStart:left_brace()\n")
    end
    fsm:clearState()
    ctxt:startToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.PercentStart:left_brace()\n")
    end
    fsm:setState(endState)
    fsm:pushState(SourceMap.Start)
    fsm:getState():Entry(fsm)
end

function TokenMap.PercentStart:sourceDone (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.PercentStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.PercentStart:sourceDone()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.PercentStart:sourceDone()\n")
    end
    fsm:setState(TokenMap.Start)
    fsm:getState():Entry(fsm)
end

function TokenMap.PercentStart:percent (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.PercentStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.PercentStart:percent()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    ctxt:endToken('EOD')
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.PercentStart:percent()\n")
    end
    fsm:setState(TokenMap.Start)
    fsm:getState():Entry(fsm)
end

function TokenMap.PercentStart:alpha (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.PercentStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.PercentStart:alpha()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.PercentStart:alpha()\n")
    end
    fsm:setState(TokenMap.PercentKeyword)
    fsm:getState():Entry(fsm)
end

function TokenMap.PercentStart:right_brace (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.PercentStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.PercentStart:right_brace()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    ctxt:badToken("End-of-source appears without matching start-of-source")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.PercentStart:right_brace()\n")
    end
    fsm:setState(TokenMap.Start)
    fsm:getState():Entry(fsm)
end

function TokenMap.PercentStart:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.PercentStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.PercentStart:Default()\n")
    end
    fsm:clearState()
    ctxt:ungetChar()
    ctxt:badToken("Unknown % directive")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.PercentStart:Default()\n")
    end
    fsm:setState(TokenMap.Start)
    fsm:getState():Entry(fsm)
end

TokenMap.PercentKeyword = TokenMap.Default:new('TokenMap.PercentKeyword', 5)

function TokenMap.PercentKeyword:alpha (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.PercentKeyword\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.PercentKeyword:alpha()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.PercentKeyword:alpha()\n")
    end
    fsm:setState(endState)
end

function TokenMap.PercentKeyword:digit (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.PercentKeyword\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.PercentKeyword:digit()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.PercentKeyword:digit()\n")
    end
    fsm:setState(endState)
end

function TokenMap.PercentKeyword:underscore (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.PercentKeyword\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.PercentKeyword:underscore()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.PercentKeyword:underscore()\n")
    end
    fsm:setState(endState)
end

function TokenMap.PercentKeyword:whitespace (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.PercentKeyword\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.PercentKeyword:whitespace()\n")
    end
    fsm:clearState()
    ctxt:ungetChar()
    ctxt:checkPercentKeyword()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.PercentKeyword:whitespace()\n")
    end
    fsm:setState(TokenMap.Start)
    fsm:getState():Entry(fsm)
end

function TokenMap.PercentKeyword:EOL (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.PercentKeyword\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.PercentKeyword:EOL()\n")
    end
    fsm:clearState()
    ctxt:checkPercentKeyword()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.PercentKeyword:EOL()\n")
    end
    fsm:setState(TokenMap.Start)
    fsm:getState():Entry(fsm)
end

function TokenMap.PercentKeyword:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.PercentKeyword\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.PercentKeyword:Default()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    ctxt:badToken("Unknown % directive")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.PercentKeyword:Default()\n")
    end
    fsm:setState(TokenMap.Start)
    fsm:getState():Entry(fsm)
end

TokenMap.Word = TokenMap.Default:new('TokenMap.Word', 6)

function TokenMap.Word:alpha (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Word\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Word:alpha()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Word:alpha()\n")
    end
    fsm:setState(endState)
end

function TokenMap.Word:digit (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Word\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Word:digit()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Word:digit()\n")
    end
    fsm:setState(endState)
end

function TokenMap.Word:underscore (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Word\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Word:underscore()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Word:underscore()\n")
    end
    fsm:setState(endState)
end

function TokenMap.Word:period (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Word\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Word:period()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Word:period()\n")
    end
    fsm:setState(endState)
end

function TokenMap.Word:colon (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Word\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Word:colon()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Word:colon()\n")
    end
    fsm:setState(TokenMap.Scope)
    fsm:getState():Entry(fsm)
end

function TokenMap.Word:whitespace (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Word\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Word:whitespace()\n")
    end
    fsm:clearState()
    ctxt:checkKeyword()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Word:whitespace()\n")
    end
    fsm:setState(TokenMap.Start)
    fsm:getState():Entry(fsm)
end

function TokenMap.Word:EOL (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Word\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Word:EOL()\n")
    end
    fsm:clearState()
    ctxt:checkKeyword()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Word:EOL()\n")
    end
    fsm:setState(TokenMap.Start)
    fsm:getState():Entry(fsm)
end

function TokenMap.Word:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Word\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Word:Default()\n")
    end
    fsm:clearState()
    ctxt:ungetChar()
    ctxt:checkKeyword()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Word:Default()\n")
    end
    fsm:setState(TokenMap.Start)
    fsm:getState():Entry(fsm)
end

TokenMap.Scope = TokenMap.Default:new('TokenMap.Scope', 7)

function TokenMap.Scope:colon (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Scope\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Scope:colon()\n")
    end
    fsm:clearState()
    ctxt:addToToken("::")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Scope:colon()\n")
    end
    fsm:setState(TokenMap.Word)
    fsm:getState():Entry(fsm)
end

function TokenMap.Scope:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.Scope\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.Scope:Default()\n")
    end
    fsm:clearState()
    ctxt:ungetChar()
    ctxt:ungetChar(":")
    ctxt:checkKeyword()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.Scope:Default()\n")
    end
    fsm:setState(TokenMap.Start)
    fsm:getState():Entry(fsm)
end

TokenMap.NeverUsed = TokenMap.Default:new('TokenMap.NeverUsed', 8)

function TokenMap.NeverUsed:unicode (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.NeverUsed\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.NeverUsed:unicode()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.NeverUsed:unicode()\n")
    end
end

function TokenMap.NeverUsed:alpha (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.NeverUsed\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.NeverUsed:alpha()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.NeverUsed:alpha()\n")
    end
end

function TokenMap.NeverUsed:digit (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.NeverUsed\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.NeverUsed:digit()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.NeverUsed:digit()\n")
    end
end

function TokenMap.NeverUsed:whitespace (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.NeverUsed\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.NeverUsed:whitespace()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.NeverUsed:whitespace()\n")
    end
end

function TokenMap.NeverUsed:EOL (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.NeverUsed\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.NeverUsed:EOL()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.NeverUsed:EOL()\n")
    end
end

function TokenMap.NeverUsed:double_quote (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.NeverUsed\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.NeverUsed:double_quote()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.NeverUsed:double_quote()\n")
    end
end

function TokenMap.NeverUsed:percent (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.NeverUsed\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.NeverUsed:percent()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.NeverUsed:percent()\n")
    end
end

function TokenMap.NeverUsed:single_quote (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.NeverUsed\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.NeverUsed:single_quote()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.NeverUsed:single_quote()\n")
    end
end

function TokenMap.NeverUsed:left_paren (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.NeverUsed\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.NeverUsed:left_paren()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.NeverUsed:left_paren()\n")
    end
end

function TokenMap.NeverUsed:right_paren (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.NeverUsed\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.NeverUsed:right_paren()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.NeverUsed:right_paren()\n")
    end
end

function TokenMap.NeverUsed:asterisk (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.NeverUsed\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.NeverUsed:asterisk()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.NeverUsed:asterisk()\n")
    end
end

function TokenMap.NeverUsed:comma (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.NeverUsed\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.NeverUsed:comma()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.NeverUsed:comma()\n")
    end
end

function TokenMap.NeverUsed:period (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.NeverUsed\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.NeverUsed:period()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.NeverUsed:period()\n")
    end
end

function TokenMap.NeverUsed:slash (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.NeverUsed\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.NeverUsed:slash()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.NeverUsed:slash()\n")
    end
end

function TokenMap.NeverUsed:colon (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.NeverUsed\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.NeverUsed:colon()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.NeverUsed:colon()\n")
    end
end

function TokenMap.NeverUsed:semicolon (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.NeverUsed\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.NeverUsed:semicolon()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.NeverUsed:semicolon()\n")
    end
end

function TokenMap.NeverUsed:left_bracket (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.NeverUsed\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.NeverUsed:left_bracket()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.NeverUsed:left_bracket()\n")
    end
end

function TokenMap.NeverUsed:right_bracket (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.NeverUsed\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.NeverUsed:right_bracket()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.NeverUsed:right_bracket()\n")
    end
end

function TokenMap.NeverUsed:underscore (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.NeverUsed\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.NeverUsed:underscore()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.NeverUsed:underscore()\n")
    end
end

function TokenMap.NeverUsed:left_brace (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.NeverUsed\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.NeverUsed:left_brace()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.NeverUsed:left_brace()\n")
    end
end

function TokenMap.NeverUsed:right_brace (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.NeverUsed\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.NeverUsed:right_brace()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.NeverUsed:right_brace()\n")
    end
end

function TokenMap.NeverUsed:equal (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.NeverUsed\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.NeverUsed:equal()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.NeverUsed:equal()\n")
    end
end

function TokenMap.NeverUsed:dollar (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.NeverUsed\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.NeverUsed:dollar()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.NeverUsed:dollar()\n")
    end
end

function TokenMap.NeverUsed:back_slash (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : TokenMap.NeverUsed\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: TokenMap.NeverUsed:back_slash()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: TokenMap.NeverUsed:back_slash()\n")
    end
end

SourceMap.Default = LexerState:new('SourceMap.Default', -1)

SourceMap.Start = SourceMap.Default:new('SourceMap.Start', 9)

function SourceMap.Start:percent (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : SourceMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: SourceMap.Start:percent()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: SourceMap.Start:percent()\n")
    end
    fsm:setState(SourceMap.SourceEnd)
    fsm:getState():Entry(fsm)
end

function SourceMap.Start:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : SourceMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: SourceMap.Start:Default()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: SourceMap.Start:Default()\n")
    end
    fsm:setState(endState)
end

SourceMap.SourceEnd = SourceMap.Default:new('SourceMap.SourceEnd', 10)

function SourceMap.SourceEnd:right_brace (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : SourceMap.SourceEnd\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: SourceMap.SourceEnd:right_brace()\n")
    end
    fsm:clearState()
    ctxt:endToken('SOURCE')
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: SourceMap.SourceEnd:right_brace()\n")
    end
    fsm:popState()
    fsm:sourceDone()
end

function SourceMap.SourceEnd:percent (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : SourceMap.SourceEnd\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: SourceMap.SourceEnd:percent()\n")
    end
    fsm:clearState()
    ctxt:addToToken("%")
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: SourceMap.SourceEnd:percent()\n")
    end
    fsm:setState(endState)
end

function SourceMap.SourceEnd:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : SourceMap.SourceEnd\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: SourceMap.SourceEnd:Default()\n")
    end
    fsm:clearState()
    ctxt:addToToken("%")
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: SourceMap.SourceEnd:Default()\n")
    end
    fsm:setState(SourceMap.Start)
    fsm:getState():Entry(fsm)
end

GuardMap.Default = LexerState:new('GuardMap.Default', -1)

GuardMap.Start = GuardMap.Default:new('GuardMap.Start', 11)

function GuardMap.Start:right_bracket (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : GuardMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: GuardMap.Start:right_bracket()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: GuardMap.Start:right_bracket()\n")
    end
    fsm:popState()
    fsm:guardDone()
end

function GuardMap.Start:left_bracket (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : GuardMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: GuardMap.Start:left_bracket()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: GuardMap.Start:left_bracket()\n")
    end
    fsm:setState(endState)
    fsm:pushState(GuardMap.Start)
    fsm:getState():Entry(fsm)
end

function GuardMap.Start:guardDone (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : GuardMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: GuardMap.Start:guardDone()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: GuardMap.Start:guardDone()\n")
    end
    fsm:setState(endState)
end

function GuardMap.Start:double_quote (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : GuardMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: GuardMap.Start:double_quote()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: GuardMap.Start:double_quote()\n")
    end
    fsm:setState(endState)
    fsm:pushState(StringDoubleMap.Start)
    fsm:getState():Entry(fsm)
end

function GuardMap.Start:single_quote (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : GuardMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: GuardMap.Start:single_quote()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: GuardMap.Start:single_quote()\n")
    end
    fsm:setState(endState)
    fsm:pushState(StringSingleMap.Start)
    fsm:getState():Entry(fsm)
end

function GuardMap.Start:stringDone (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : GuardMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: GuardMap.Start:stringDone()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: GuardMap.Start:stringDone()\n")
    end
    fsm:setState(endState)
end

function GuardMap.Start:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : GuardMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: GuardMap.Start:Default()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: GuardMap.Start:Default()\n")
    end
    fsm:setState(endState)
end

ParamTypeMap.Default = LexerState:new('ParamTypeMap.Default', -1)

ParamTypeMap.Start = ParamTypeMap.Default:new('ParamTypeMap.Start', 12)

function ParamTypeMap.Start:right_paren (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ParamTypeMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ParamTypeMap.Start:right_paren()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ParamTypeMap.Start:right_paren()\n")
    end
    fsm:popState()
    fsm:paramDone()
end

function ParamTypeMap.Start:comma (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ParamTypeMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ParamTypeMap.Start:comma()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ParamTypeMap.Start:comma()\n")
    end
    fsm:popState()
    fsm:paramDone()
end

function ParamTypeMap.Start:left_paren (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ParamTypeMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ParamTypeMap.Start:left_paren()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ParamTypeMap.Start:left_paren()\n")
    end
    fsm:setState(endState)
    fsm:pushState(ParamTypeMap.Start)
    fsm:getState():Entry(fsm)
end

function ParamTypeMap.Start:paramDone (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ParamTypeMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ParamTypeMap.Start:paramDone()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ParamTypeMap.Start:paramDone()\n")
    end
    fsm:setState(endState)
end

function ParamTypeMap.Start:double_quote (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ParamTypeMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ParamTypeMap.Start:double_quote()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ParamTypeMap.Start:double_quote()\n")
    end
    fsm:setState(endState)
    fsm:pushState(StringDoubleMap.Start)
    fsm:getState():Entry(fsm)
end

function ParamTypeMap.Start:single_quote (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ParamTypeMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ParamTypeMap.Start:single_quote()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ParamTypeMap.Start:single_quote()\n")
    end
    fsm:setState(endState)
    fsm:pushState(StringSingleMap.Start)
    fsm:getState():Entry(fsm)
end

function ParamTypeMap.Start:stringDone (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ParamTypeMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ParamTypeMap.Start:stringDone()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ParamTypeMap.Start:stringDone()\n")
    end
    fsm:setState(endState)
end

function ParamTypeMap.Start:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : ParamTypeMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: ParamTypeMap.Start:Default()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: ParamTypeMap.Start:Default()\n")
    end
    fsm:setState(endState)
end

StringDoubleMap.Default = LexerState:new('StringDoubleMap.Default', -1)

StringDoubleMap.Start = StringDoubleMap.Default:new('StringDoubleMap.Start', 13)

function StringDoubleMap.Start:double_quote (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : StringDoubleMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: StringDoubleMap.Start:double_quote()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: StringDoubleMap.Start:double_quote()\n")
    end
    fsm:popState()
    fsm:stringDone()
end

function StringDoubleMap.Start:back_slash (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : StringDoubleMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: StringDoubleMap.Start:back_slash()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: StringDoubleMap.Start:back_slash()\n")
    end
    fsm:setState(StringDoubleMap.Escape)
    fsm:getState():Entry(fsm)
end

function StringDoubleMap.Start:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : StringDoubleMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: StringDoubleMap.Start:Default()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: StringDoubleMap.Start:Default()\n")
    end
    fsm:setState(endState)
end

StringDoubleMap.Escape = StringDoubleMap.Default:new('StringDoubleMap.Escape', 14)

function StringDoubleMap.Escape:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : StringDoubleMap.Escape\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: StringDoubleMap.Escape:Default()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: StringDoubleMap.Escape:Default()\n")
    end
    fsm:setState(StringDoubleMap.Start)
    fsm:getState():Entry(fsm)
end

StringSingleMap.Default = LexerState:new('StringSingleMap.Default', -1)

StringSingleMap.Start = StringSingleMap.Default:new('StringSingleMap.Start', 15)

function StringSingleMap.Start:single_quote (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : StringSingleMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: StringSingleMap.Start:single_quote()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: StringSingleMap.Start:single_quote()\n")
    end
    fsm:popState()
    fsm:stringDone()
end

function StringSingleMap.Start:back_slash (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : StringSingleMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: StringSingleMap.Start:back_slash()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: StringSingleMap.Start:back_slash()\n")
    end
    fsm:setState(StringSingleMap.Escape)
    fsm:getState():Entry(fsm)
end

function StringSingleMap.Start:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : StringSingleMap.Start\n")
    end
    local endState = fsm:getState()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: StringSingleMap.Start:Default()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: StringSingleMap.Start:Default()\n")
    end
    fsm:setState(endState)
end

StringSingleMap.Escape = StringSingleMap.Default:new('StringSingleMap.Escape', 16)

function StringSingleMap.Escape:Default (fsm)
    local ctxt = fsm:getOwner()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : StringSingleMap.Escape\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: StringSingleMap.Escape:Default()\n")
    end
    fsm:clearState()
    ctxt:addToToken()
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: StringSingleMap.Escape:Default()\n")
    end
    fsm:setState(StringSingleMap.Start)
    fsm:getState():Entry(fsm)
end

NewCommentMap.Default = LexerState:new('NewCommentMap.Default', -1)

NewCommentMap.Start = NewCommentMap.Default:new('NewCommentMap.Start', 17)

function NewCommentMap.Start:EOL (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : NewCommentMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: NewCommentMap.Start:EOL()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: NewCommentMap.Start:EOL()\n")
    end
    fsm:popState()
    fsm:commentDone()
end

function NewCommentMap.Start:Default (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : NewCommentMap.Start\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: NewCommentMap.Start:Default()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: NewCommentMap.Start:Default()\n")
    end
end

OldCommentMap.Default = LexerState:new('OldCommentMap.Default', -1)

OldCommentMap.Start = OldCommentMap.Default:new('OldCommentMap.Start', 18)

function OldCommentMap.Start:slash (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : OldCommentMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: OldCommentMap.Start:slash()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: OldCommentMap.Start:slash()\n")
    end
    fsm:setState(OldCommentMap.CommentStart)
    fsm:getState():Entry(fsm)
end

function OldCommentMap.Start:asterisk (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : OldCommentMap.Start\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: OldCommentMap.Start:asterisk()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: OldCommentMap.Start:asterisk()\n")
    end
    fsm:setState(OldCommentMap.CommentEnd)
    fsm:getState():Entry(fsm)
end

function OldCommentMap.Start:Default (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : OldCommentMap.Start\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: OldCommentMap.Start:Default()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: OldCommentMap.Start:Default()\n")
    end
end

OldCommentMap.CommentStart = OldCommentMap.Default:new('OldCommentMap.CommentStart', 19)

function OldCommentMap.CommentStart:asterisk (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : OldCommentMap.CommentStart\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: OldCommentMap.CommentStart:asterisk()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: OldCommentMap.CommentStart:asterisk()\n")
    end
    fsm:pushState(OldCommentMap.Start)
    fsm:getState():Entry(fsm)
end

function OldCommentMap.CommentStart:slash (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : OldCommentMap.CommentStart\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: OldCommentMap.CommentStart:slash()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: OldCommentMap.CommentStart:slash()\n")
    end
    fsm:pushState(NewCommentMap.Start)
    fsm:getState():Entry(fsm)
end

function OldCommentMap.CommentStart:Default (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : OldCommentMap.CommentStart\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: OldCommentMap.CommentStart:Default()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: OldCommentMap.CommentStart:Default()\n")
    end
    fsm:setState(OldCommentMap.Start)
    fsm:getState():Entry(fsm)
end

OldCommentMap.CommentEnd = OldCommentMap.Default:new('OldCommentMap.CommentEnd', 20)

function OldCommentMap.CommentEnd:asterisk (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : OldCommentMap.CommentEnd\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: OldCommentMap.CommentEnd:asterisk()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: OldCommentMap.CommentEnd:asterisk()\n")
    end
end

function OldCommentMap.CommentEnd:slash (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : OldCommentMap.CommentEnd\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: OldCommentMap.CommentEnd:slash()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: OldCommentMap.CommentEnd:slash()\n")
    end
    fsm:popState()
    fsm:commentDone()
end

function OldCommentMap.CommentEnd:Default (fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("LEAVING STATE   : OldCommentMap.CommentEnd\n")
    end
    fsm:getState():Exit(fsm)
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("ENTER TRANSITION: OldCommentMap.CommentEnd:Default()\n")
    end
    if fsm:getDebugFlag() then
        fsm:getDebugStream():write("EXIT TRANSITION: OldCommentMap.CommentEnd:Default()\n")
    end
    fsm:setState(OldCommentMap.Start)
    fsm:getState():Entry(fsm)
end

LexerContext = statemap.FSMContext:class()

function LexerContext:_init ()
    self:setState(TokenMap.Start)
end

function LexerContext:left_paren ()
    self._transition = 'left_paren'
    self:getState():left_paren(self)
    self._transition = nil
end

function LexerContext:left_bracket ()
    self._transition = 'left_bracket'
    self:getState():left_bracket(self)
    self._transition = nil
end

function LexerContext:left_brace ()
    self._transition = 'left_brace'
    self:getState():left_brace(self)
    self._transition = nil
end

function LexerContext:digit ()
    self._transition = 'digit'
    self:getState():digit(self)
    self._transition = nil
end

function LexerContext:asterisk ()
    self._transition = 'asterisk'
    self:getState():asterisk(self)
    self._transition = nil
end

function LexerContext:period ()
    self._transition = 'period'
    self:getState():period(self)
    self._transition = nil
end

function LexerContext:underscore ()
    self._transition = 'underscore'
    self:getState():underscore(self)
    self._transition = nil
end

function LexerContext:double_quote ()
    self._transition = 'double_quote'
    self:getState():double_quote(self)
    self._transition = nil
end

function LexerContext:back_slash ()
    self._transition = 'back_slash'
    self:getState():back_slash(self)
    self._transition = nil
end

function LexerContext:raw3 ()
    self._transition = 'raw3'
    self:getState():raw3(self)
    self._transition = nil
end

function LexerContext:slash ()
    self._transition = 'slash'
    self:getState():slash(self)
    self._transition = nil
end

function LexerContext:dollar ()
    self._transition = 'dollar'
    self:getState():dollar(self)
    self._transition = nil
end

function LexerContext:commentDone ()
    self._transition = 'commentDone'
    self:getState():commentDone(self)
    self._transition = nil
end

function LexerContext:EOL ()
    self._transition = 'EOL'
    self:getState():EOL(self)
    self._transition = nil
end

function LexerContext:percent ()
    self._transition = 'percent'
    self:getState():percent(self)
    self._transition = nil
end

function LexerContext:raw2 ()
    self._transition = 'raw2'
    self:getState():raw2(self)
    self._transition = nil
end

function LexerContext:right_paren ()
    self._transition = 'right_paren'
    self:getState():right_paren(self)
    self._transition = nil
end

function LexerContext:right_brace ()
    self._transition = 'right_brace'
    self:getState():right_brace(self)
    self._transition = nil
end

function LexerContext:single_quote ()
    self._transition = 'single_quote'
    self:getState():single_quote(self)
    self._transition = nil
end

function LexerContext:guardDone ()
    self._transition = 'guardDone'
    self:getState():guardDone(self)
    self._transition = nil
end

function LexerContext:stringDone ()
    self._transition = 'stringDone'
    self:getState():stringDone(self)
    self._transition = nil
end

function LexerContext:raw1 ()
    self._transition = 'raw1'
    self:getState():raw1(self)
    self._transition = nil
end

function LexerContext:sourceDone ()
    self._transition = 'sourceDone'
    self:getState():sourceDone(self)
    self._transition = nil
end

function LexerContext:alpha ()
    self._transition = 'alpha'
    self:getState():alpha(self)
    self._transition = nil
end

function LexerContext:colon ()
    self._transition = 'colon'
    self:getState():colon(self)
    self._transition = nil
end

function LexerContext:semicolon ()
    self._transition = 'semicolon'
    self:getState():semicolon(self)
    self._transition = nil
end

function LexerContext:comma ()
    self._transition = 'comma'
    self:getState():comma(self)
    self._transition = nil
end

function LexerContext:unicode ()
    self._transition = 'unicode'
    self:getState():unicode(self)
    self._transition = nil
end

function LexerContext:right_bracket ()
    self._transition = 'right_bracket'
    self:getState():right_bracket(self)
    self._transition = nil
end

function LexerContext:equal ()
    self._transition = 'equal'
    self:getState():equal(self)
    self._transition = nil
end

function LexerContext:whitespace ()
    self._transition = 'whitespace'
    self:getState():whitespace(self)
    self._transition = nil
end

function LexerContext:paramDone ()
    self._transition = 'paramDone'
    self:getState():paramDone(self)
    self._transition = nil
end

function LexerContext:enterStartState ()
    self:getState():Entry(self)
end

function LexerContext:getOwner ()
    return self._owner
end

-- Local variables:
--  buffer-read-only: t
-- End:
