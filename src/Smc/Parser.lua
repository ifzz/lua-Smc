

require 'Coat'
require 'Coat.Types'

local string = require 'string'
local table = require 'table'
local tostring = tostring

class 'Smc.Token'

enum.Smc.TokenType = {
    'DONE_FAILED',
    'DONE_SUCCESS',
    'SOURCE',
    'WORD',
    -- ponctuations
    'LEFT_PAREN',
    'RIGHT_PAREN',
    'COMMA',
    'SLASH',
    'COLON',
    'SEMICOLON',
    'LEFT_BRACKET',
    'LEFT_BRACE',
    'RIGHT_BRACE',
    'EQUAL',
    'DOLLAR',
    'EOD', -- %%
    -- keywords
    'ENTRY',
    'EXIT',
    'JUMP',
    'POP',
    'PUSH',
    -- %keywords
    'ACCESS',
    'CLASS_NAME',
    'DECLARE',
    'FSM_CLASS_NAME',
    'FSM_FILE_NAME',
    'HEADER_FILE',
    'IMPORT',
    'INCLUDE_FILE',
    'MAP_NAME',
    'PACKAGE_NAME',
    'SOURCE_FILE',
    'START_STATE',
}

has._type           = { is = 'rw', isa = 'Smc.TokenType' }
has.value           = { is = 'rw', isa = 'string' }
has.lineno          = { is = 'rw', isa = 'number' }

function overload:__tostring ()
    return '"' .. self.value .. '"'
end


class 'Smc.Lexer'

require 'Coat.file'

has.filename        = { is = 'ro', isa = 'string', required = true }
has.stream          = { is = 'ro', isa = 'file', required = true }
has.debugFlag       = { is = 'ro', isa = 'boolean', default = false }
has.prev            = { is = 'ro', isa = 'Smc.Lexer' }
has.lexerFSM        = { is = 'ro' }
has.transMethod     = { is = 'ro', isa = 'table<string,string>', lazy_build = true }
has.keyword         = { is = 'ro', isa = 'table<string,Smc.TokenType>', lazy_build = true }
has.percentKeyword  = { is = 'ro', isa = 'table<string,Smc.TokenType>', lazy_build = true }
has.currentChar     = { is = 'rw', isa = 'string'}
has.token           = { is = 'rw', isa = 'Smc.Token'}
has.tokenBuffer     = { is = 'rw', isa = 'string'}
has.lineno          = { is = 'rw', isa = 'number', default = 1 }
has.stopFlag        = { is = 'rw', isa = 'boolean' }
has.lookahead       = { is = 'rw', isa = 'table<string>',
                        default = function () return {} end }

function method:_build_transMethod ()
    local t = {
        ['\t'] = 'whitespace',
        ['\v'] = 'whitespace',
        ['\f'] = 'whitespace',
        ['\n'] = 'EOL',
        ['\r'] = 'EOL',
        [' '] = 'whitespace',
        ['"'] = 'double_quote',
        ['$'] = 'dollar',
        ['%'] = 'percent',
        ["'"] = 'single_quote',
        ['('] = 'left_paren',
        [')'] = 'right_paren',
        ['*'] = 'asterisk',
        [','] = 'comma',
        ['.'] = 'period',
        ['/'] = 'slash',
        [':'] = 'colon',
        [';'] = 'semicolon',
        ['['] = 'left_bracket',
        [']'] = 'right_bracket',
        ['_'] = 'underscore',
        ['{'] = 'left_brace',
        ['}'] = 'right_brace',
        ['='] = 'equal',
        ['\\'] = 'back_slash',
    }
    for c in string.gmatch('0123456789', '.') do
        t[c] = 'digit'
    end
    for c in string.gmatch('ABCDEFGHIJKLMNOPQRSTUVWXYZ', '.') do
        t[c] = 'alpha'
        t[c:lower()] = 'alpha'
    end
    return t
end

function method:_build_keyword ()
    return {
        Entry   = 'ENTRY',
        Exit    = 'EXIT',
        jump    = 'JUMP',
        pop     = 'POP',
        push    = 'PUSH',
    }
end

function method:_build_percentKeyword ()
    return {
        ['%access']     = 'ACCESS',
        ['%class']      = 'CLASS_NAME',
        ['%declare']    = 'DECLARE',
        ['%fsmclass']   = 'FSM_CLASS_NAME',
        ['%fsmfile']    = 'FSM_FILE_NAME',
        ['%header']     = 'HEADER_FILE',
        ['%import']     = 'IMPORT',
        ['%include']    = 'INCLUDE_FILE',
        ['%map']        = 'MAP_NAME',
        ['%package']    = 'PACKAGE_NAME',
        ['%source']     = 'SOURCE_FILE',
        ['%start']      = 'START_STATE',
    }
end

function method:BUILD ()
    self.lexerFSM = require 'Smc.Parser.Lexer_sm':new{owner = self}
--    self.lexerFSM.debugFlag = self.debugFlag
    self.token = Smc.Token.new()
end

function method:ungetChar (char)
    table.insert(self.lookahead, char or self.currentChar)
end

function method:nextToken ()
    function readChar ()
        if #self.lookahead > 0 then
            return table.remove(self.lookahead)
        else
            return self.stream:read(1)
        end
    end -- readChar

    self.stopFlag = false
    while not self.stopFlag do
        local currentChar = readChar()
        self.currentChar = currentChar
        if currentChar == nil then -- EOF
            self.token._type = 'DONE_SUCCESS'
            self.token.value = ''
            break
        end
        if currentChar == '\n' then
            self.lineno = self.lineno + 1
        end
        local meth = self.lexerFSM[self.transMethod[currentChar] or 'unicode']
        meth(self.lexerFSM)
    end
    return self.token
end

function method:setRawMode ()
    self.lexerFSM:raw1()
end

function method:setRawMode2 ()
    self.lexerFSM:raw2()
end

function method:setRawMode3 ()
    self.lexerFSM:raw3()
end

-- State Map Actions
function method:startToken ()
    self.token._type = nil
    self.token.value = nil
    self.token.lineno = self.lineno
    self.tokenBuffer = ''
end

function method:addToToken (str)
    str = str or self.currentChar
    self.tokenBuffer = self.tokenBuffer .. str
end

function method:endToken (_type)
    self.token._type = _type
    self.token.value = self.tokenBuffer
    self.stopFlag = true
end

function method:trimToken ()
    local str = self.token.value
    self.token.value = str:gsub("^%s+", ''):gsub("%s+$", '')
end

function method:badToken (error_msg)
    self.token._type = 'DONE_FAILED'
    self.token.value = error_msg .. " (token:" .. self.tokenBuffer .. ")"
    self.stopFlag = true
end

function method:checkKeyword ()
    local str = self.tokenBuffer
    assert(str:len() > 0)
    local _type = self.keyword[str]
    self.token.value = str
    self.stopFlag = true
    if _type then
        self.token._type = _type
    else
        self.token._type = 'WORD'
    end
end

function method:checkPercentKeyword ()
    local str = self.tokenBuffer
    local _type = self.percentKeyword[str]
    self.token.value = str
    self.stopFlag = true
    if _type then
        self.token._type = _type
    else
        self:badToken("Unknown % directive")
    end
end


class 'Smc.Message'

enum.Smc.MsgLevel = { 'WARNING', 'ERROR' }

has.filename        = { is = 'ro', isa = 'string', required = true }
has.lineno          = { is = 'ro', isa = 'number', required = true }
has.level           = { is = 'ro', isa = 'Smc.MsgLevel', required = true }
has.text            = { is = 'ro', isa = 'string', required = true }

function overload:__tostring ()
    return self.filename .. ":" .. tostring(self.lineno) .. ": "
        .. self.level:lower() .. " - " .. self.text
end


class 'Smc.Parser'

require 'Smc.Model'

has.name            = { is = 'ro', isa = 'string', required = true }
has.filename        = { is = 'ro', isa = 'string', required = true }
has.stream          = { is = 'ro', isa = 'file', required = true }
has.targetLanguage  = { is = 'ro', isa = 'string', required = true }
has.targetFilename  = { is = 'ro', isa = 'string', required = true }
has.debugFlag       = { is = 'ro', isa = 'boolean', default = false }
has.parserFSM       = { is = 'ro' }
has.lexer           = { is = 'rw', isa = 'Smc.Lexer',
                        handles = { 'setRawMode', 'setRawMode2', 'setRawMode3' } }
has.fsm             = { is = 'ro', isa = 'Smc.FSM', reset = true }
has.mapInProgress   = { is = 'ro', isa = 'Smc.Map', reset = true }
has.stateInProgress = { is = 'ro', isa = 'Smc.State', reset = true }
has.transitionInProgress = { is = 'ro', isa = 'Smc.Transition', reset = true }
has.transitionName  = { is = 'ro', isa = 'string', reset = true }
has.paramInProgress = { is = 'ro', isa = 'Smc.Parameter', reset = true }
has.guardInProgress = { is = 'ro', isa = 'Smc.Guard', reset = true }
has.actionInProgress= { is = 'ro', isa = 'Smc.Action', reset = true }
has.argInProgress   = { is = 'ro', isa = 'string', reset = true }
has.paramList       = { is = 'ro', isa = 'table<Smc.Parameter>', reset = true }
has.actionList      = { is = 'ro', isa = 'table<Smc.Action>', reset = true }
has.argList         = { is = 'ro', isa = 'table<string>', reset = true }
has.messages        = { is = 'rw', isa = 'table<Smc.Message>',
                        default = function () return {} end }

function method:BUILD ()
    self.parserFSM = require 'Smc.Parser.Parser_sm':new{owner = self}
    self.parserFSM.debugFlag = self.debugFlag
    self.lexer = Smc.Lexer.new{
        filename = self.filename,
        stream = self.stream,
        debugFlag = self.debugFlag
    }
end

function method:parse ()
    local function dirname (filename)
        filename = filename:reverse()
        local idx = filename:find"/"
        if idx then
            filename = filename:sub(idx+1)
            return filename:reverse()
        else
            return "."
        end
    end -- dirname

    self.fsm = Smc.FSM.new{
        name = self.name,
        filename = self.filename,
        lineno = 1,
        targetFilename = self.targetFilename,
    }
    while true do
        local lexer = self.lexer
        local token = lexer:nextToken()
        assert(token._type)
        if token._type == 'SOURCE_FILE' then
            lexer:setRawMode3()
            token = lexer:nextToken()
            assert(token._type == 'SOURCE')
            local filename = dirname(lexer.filename) .. '/' .. token.value
            local f, msg = io.open(filename, 'r')
            if f == nil then
                self:_error("Cannot open " .. filename .. " (" .. msg .. ")", token.lineno)
            else
                self.lexer = Smc.Lexer.new{
                    filename = filename,
                    stream = f,
                    prev = lexer,
                    debugFlag = self.debugFlag,
                }
            end
        elseif token._type == 'DONE_FAILED' then
            self:_error(token.value, token.lineno)
            self.fsm = nil
            break
        elseif token._type == 'DONE_SUCCESS' then
            local prev = lexer.prev
            if prev then
                self.lexer = prev
            else
                break
            end
        else
            local meth = self.parserFSM[token._type]
            meth(self.parserFSM, token)
        end
    end
    return self.fsm
end

--State Machine Actions
function method:warning (text, lineno)
    local lexer = self.lexer
    local msg = Smc.Message.new{
        filename = lexer.filename,
        lineno = lineno or lexer.lineno,
        level = 'WARNING',
        text = text,
    }
--    print(msg)
    table.insert(self.messages, msg)
end

function method:_error (text, lineno)
    local lexer = self.lexer
    local msg = Smc.Message.new{
        filename = lexer.filename,
        lineno = lineno or lexer.lineno,
        level = 'ERROR',
        text = text,
    }
--    print(msg)
    table.insert(self.messages, msg)
    self.fsm.isValid = false
end

function method:setSource (token)
    if self.fsm.source then
        self:warning("%{ %} source previously specified, new source ignored.", token.lineno)
    else
        self.fsm.source = token.value
    end
end

function method:setStartState (token)
    if self.fsm.startState then
        self:warning("%start previously specified, new start state ignored.", token.lineno)
    else
        local val = token.value
        local idx = val:find'::'
        if not idx or val:sub(idx+2):find'::' then
            self:_error("Start state must be of the form \"map::state\".", token.lineno)
        end
        self.fsm.startState = val
    end
end

function method:setContext (token)
    if self.fsm.context then
        self:warning("%class previously specified, new context ignored.", token.lineno)
    else
        self.fsm.context = token.value
    end
end

function method:setFsmClassName (token)
    -- lazy default
    self.fsm.fsmClassname = token.value
end

function method:setFsmFileName (token)
    self.fsm.targetFilename = token.value
end

function method:setPackageName (token)
    if self.fsm._package then
        self:warning("%package previously specified, new package ignored.", token.lineno)
    else
        self.fsm._package = token.value
    end
end

function method:setAccessLevel (token)
    if self.fsm.accessLevel then
        self:warning("%access previously specified, new access level ignored.", token.lineno)
    else
        self.fsm.accessLevel = token.value
    end
end

function method:addImport (token)
    table.insert(self.fsm.importList, token.value)
end

function method:addDeclare (token)
    local decl = token.value
    if not decl:match ";$" then
        decl = decl .. ";"
    end
    table.insert(self.fsm.declareList, decl)
end

function method:setHeader (token)
    if self.fsm.header then
        self:warning("%header previously specified, new header file ignored.", token.lineno)
    else
        self.fsm.header = token.value
        self:addInclude(token)
    end
end

function method:addInclude (token)
    local include = token.value
    local c = include:sub(1, 1)
    if c ~= '"' and c ~= '<' then
        include = '"' .. include .. '"'
    end
    table.insert(self.fsm.includeList, include)
end

function method:addMap ()
    self.fsm:addMap(self.mapInProgress)
    self.mapInProgress = nil
end

function method:createMap (token)
    local name = token.value
    if self.fsm:findMap(name) then
        self:_error("Duplicate map name.", token.lineno)
    end
    local lexer = self.lexer
    self.mapInProgress = Smc.Map.new{
        name = name,
        filename = lexer.filename,
        lineno = lexer.lineno,
        fsm = self.fsm,
    }
end

function method:addState ()
    self.mapInProgress:addState(self.stateInProgress)
    self.stateInProgress = nil
end

function method:createState (token)
    local name = token.value
    if name:lower() == 'default' then
        name = 'DefaultState'
    end
    if self.mapInProgress:isKnownState(name) then
        self:_error("Duplicate state name.", token.lineno)
    end
    local lexer = self.lexer
    self.stateInProgress = Smc.State.new{
        name = name,
        filename = lexer.filename,
        lineno = lexer.lineno,
        map = self.mapInProgress,
    }
end

function method:setEntryAction ()
    if     self.stateInProgress.isDefault then
        self:_error("Default state may not have an entry action.", self.stateInProgress.lineno)
    elseif self.stateInProgress.entryActions then
        self:warning "Entry action previously specified, new entry action ignored."
    else
        self.stateInProgress.entryActions = self.actionList
    end
    self.actionList = nil
end

function method:setExitAction ()
    if     self.stateInProgress.isDefault then
        self:_error("Default state may not have an exit action.", self.stateInProgress.lineno)
    elseif self.stateInProgress.exitActions then
        self:warning "Exit action previously specified, new exit action ignored."
    else
        self.stateInProgress.exitActions = self.actionList
    end
    self.actionList = nil
end

function method:addTransition ()
    self.stateInProgress:addTransition(self.transitionInProgress)
    self.transitionInProgress = nil
end

function method:storeTransitionName (token)
    self.transitionName = token.value
end

function method:createTransition ()
    local name = self.transitionName
    if name:lower() == 'default' then
        name = 'Default'
    end
    local params = self.paramList or {}
    local lexer = self.lexer
    self.transitionInProgress =
        self.stateInProgress:findTransition(name)
     or Smc.Transition.new{
            name = name,
            filename = lexer.filename,
            lineno = lexer.lineno,
            state = self.stateInProgress,
            parameters = params,
        }
    if name == "Default" and #params > 0 then
        self:_error "Default transition with parameter."
    end
    self.transitionName = nil
    self.paramList = nil
end

function method:addGuard ()
    self.transitionInProgress:addGuard(self.guardInProgress)
    self.guardInProgress = nil
end

function method:createGuard (token)
    local lexer = self.lexer
    self.guardInProgress = Smc.Guard.new{
        name = self.transitionInProgress.name,
        filename = lexer.filename,
        lineno = (token and token.lineno) or lexer.lineno,
        condition = (token and token.value) or '',
        transition = self.transitionInProgress,
    }
end

function method:setTransType (trans_type)
    self.guardInProgress.transType = trans_type
    if trans_type == 'TRANS_POP' then
        self.guardInProgress.popArgs = ''
    end
end

function method:setEndState (token)
    local guard = self.guardInProgress
    assert(guard.transType)
    self.guardInProgress.endState = (token and token.value) or 'nil'
end

function method:setPushState (token)
    local guard = self.guardInProgress
    assert(guard.transType == 'TRANS_PUSH',
           "Cannot set push state on a non-push transition.")
    guard.pushState = token.value
end

function method:setActions ()
    self.guardInProgress.actions = self.actionList
    self.actionList = nil
end

function method:setPopArgs ()
    local guard = self.guardInProgress
    assert(guard.transType == 'TRANS_POP',
           "Cannot set pop args on a non-pop transition.")
    guard.popArgs = table.concat(self.argList, ", ")
    self.argList = nil
end

function method:createParamList ()
    self.paramList = {}
end

function method:createParameter (token, dollar)
    local lexer = self.lexer
    self.paramInProgress = Smc.Parameter.new{
        name = (dollar or '') .. token.value,
        filename = lexer.filename,
        lineno = lexer.lineno,
    }
end

function method:setParamType (token)
    self.paramInProgress._type = token.value
end

function method:addParameter ()
    table.insert(self.paramList, self.paramInProgress)
    self.paramInProgress = nil
end

function method:clearParameter ()
    self.paramInProgress = nil
end

function method:createActionList ()
    self.actionList = {}
end

function method:setProperty ()
    self.actionInProgress.propertyFlag = true
end

function method:clearActions ()
    self.actionList = nil
end

function method:createAction (token)
    local lexer = self.lexer
    self.actionInProgress = Smc.Action{
        name = token.value,
        filename = lexer.filename,
        lineno = lexer.lineno,
    }
end

function method:setActionArgs ()
    self.actionInProgress.arguments = self.argList
    self.argList = nil
end

function method:addAction ()
    table.insert(self.actionList, self.actionInProgress)
    self.actionInProgress = nil
end

function method:createArgList ()
    self.argList = {}
end

function method:clearArguments ()
    self.argList = nil
end

function method:createArgument (token)
    local arg = token.value
    if arg ~= '' then
        self.argInProgress = arg
    end
end

function method:addArgument ()
    table.insert(self.argList, self.argInProgress)
    self.argInProgress = nil
end
