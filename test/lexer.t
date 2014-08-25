#!/usr/bin/env lua

require 'Smc.Parser'

require 'Test.More'
require 'io'

plan(156)

function do_parse (text)
    local f = io.tmpfile()
    f:write(text)
    f:seek 'set'
    local lexer = Smc.Lexer.new{
        name = 'test',
        filename = '<tmpfile>',
        stream = f,
    }
    assert(lexer:isa 'Smc.Lexer')
    return lexer
end

local token, lexer
lexer = do_parse " ( ) , / : ; [ { } = $ %% @ "
token = lexer:nextToken()
is( token._type, 'LEFT_PAREN', "ponctuation" )
is( token.value, '(' )
token = lexer:nextToken()
is( token._type, 'RIGHT_PAREN' )
is( token.value, ')' )
token = lexer:nextToken()
is( token._type, 'COMMA' )
is( token.value, ',' )
token = lexer:nextToken()
is( token._type, 'SLASH' )
is( token.value, '/' )
token = lexer:nextToken()
is( token._type, 'COLON' )
is( token.value, ':' )
token = lexer:nextToken()
is( token._type, 'SEMICOLON' )
is( token.value, ';' )
token = lexer:nextToken()
is( token._type, 'LEFT_BRACKET' )
is( token.value, '[' )
token = lexer:nextToken()
is( token._type, 'LEFT_BRACE' )
is( token.value, '{' )
token = lexer:nextToken()
is( token._type, 'RIGHT_BRACE' )
is( token.value, '}' )
token = lexer:nextToken()
is( token._type, 'EQUAL' )
is( token.value, '=' )
token = lexer:nextToken()
is( token._type, 'DOLLAR' )
is( token.value, '$' )
token = lexer:nextToken()
is( token._type, 'EOD' )
is( token.value, '%%' )
token = lexer:nextToken()
is( token._type, 'DONE_FAILED' )
is( token.value, 'Unknown token (token:@)' )
token = lexer:nextToken()
is( token._type, 'DONE_SUCCESS' )


lexer = do_parse " word _word-2 scope::word3 $inner$ value:type "
token = lexer:nextToken()
is( token._type, 'WORD', "words" )
is( token.value, 'word' )
token = lexer:nextToken()
is( token._type, 'WORD')
is( token.value, '_word_2' )
token = lexer:nextToken()
is( token._type, 'WORD')
is( token.value, 'scope::word3' )
token = lexer:nextToken()
is( token._type, 'DOLLAR')
is( token.value, '$' )
token = lexer:nextToken()
is( token._type, 'WORD')
is( token.value, 'inner' )
token = lexer:nextToken()
is( token._type, 'DOLLAR')
is( token.value, '$' )
token = lexer:nextToken()
is( token._type, 'WORD')
is( token.value, 'value' )
token = lexer:nextToken()
is( token._type, 'COLON')
is( token.value, ':' )
token = lexer:nextToken()
is( token._type, 'WORD')
is( token.value, 'type' )
token = lexer:nextToken()
is( token._type, 'DONE_SUCCESS' )


lexer = do_parse " Entry Exit jump pop push EXIT "
token = lexer:nextToken()
is( token._type, 'ENTRY', "keywords" )
is( token.value, 'Entry' )
token = lexer:nextToken()
is( token._type, 'EXIT' )
is( token.value, 'Exit' )
token = lexer:nextToken()
is( token._type, 'JUMP' )
is( token.value, 'jump' )
token = lexer:nextToken()
is( token._type, 'POP' )
is( token.value, 'pop' )
token = lexer:nextToken()
is( token._type, 'PUSH' )
is( token.value, 'push' )
token = lexer:nextToken()
is( token._type, 'WORD' )
is( token.value, 'EXIT' )
token = lexer:nextToken()
is( token._type, 'DONE_SUCCESS' )


lexer = do_parse " %access %class %declare %fsmclass %header %import %include %map %package %source %start "
token = lexer:nextToken()
is( token._type, 'ACCESS', "%keywords" )
is( token.value, '%access' )
token = lexer:nextToken()
is( token._type, 'CLASS_NAME' )
is( token.value, '%class' )
token = lexer:nextToken()
is( token._type, 'DECLARE' )
is( token.value, '%declare' )
token = lexer:nextToken()
is( token._type, 'FSM_CLASS_NAME' )
is( token.value, '%fsmclass' )
token = lexer:nextToken()
is( token._type, 'HEADER_FILE' )
is( token.value, '%header' )
token = lexer:nextToken()
is( token._type, 'IMPORT' )
is( token.value, '%import' )
token = lexer:nextToken()
is( token._type, 'INCLUDE_FILE' )
is( token.value, '%include' )
token = lexer:nextToken()
is( token._type, 'MAP_NAME' )
is( token.value, '%map' )
token = lexer:nextToken()
is( token._type, 'PACKAGE_NAME' )
is( token.value, '%package' )
token = lexer:nextToken()
is( token._type, 'SOURCE_FILE' )
is( token.value, '%source' )
token = lexer:nextToken()
is( token._type, 'START_STATE' )
is( token.value, '%start' )
token = lexer:nextToken()
is( token._type, 'DONE_SUCCESS' )


lexer = do_parse " %Access %bad %  %} "
token = lexer:nextToken()
is( token._type, 'DONE_FAILED', "bad %keywords" )
is( token.value, 'Unknown % directive (token:%Access)' )
token = lexer:nextToken()
is( token._type, 'DONE_FAILED' )
is( token.value, 'Unknown % directive (token:%bad)' )
token = lexer:nextToken()
is( token._type, 'DONE_FAILED' )
is( token.value, 'Unknown % directive (token:%)' )
token = lexer:nextToken()
is( token._type, 'DONE_FAILED' )
is( token.value, 'End-of-source appears without matching start-of-source (token:%})' )
token = lexer:nextToken()
is( token._type, 'DONE_SUCCESS' )


lexer = do_parse [===[

%{
    % raw code }{ %%
%}

]===]
token = lexer:nextToken()
is( token._type, 'SOURCE', "raw source" )
is( token.value, "\n    % raw code }{ %%\n" )
token = lexer:nextToken()
is( token._type, 'DONE_SUCCESS' )


lexer = do_parse " [ cond( param1, param2 ) ] "
token = lexer:nextToken()
is( token._type, 'LEFT_BRACKET', "raw (guard condition)" )
is( token.value, '[' )
lexer:setRawMode()
token = lexer:nextToken()
is( token._type, 'SOURCE' )
is( token.value, 'cond( param1, param2 )' )
token = lexer:nextToken()
is( token._type, 'DONE_SUCCESS' )


lexer = do_parse [===[ [ cond( param1, param2[3], "str\" ] ing" ) ] ]===]
token = lexer:nextToken()
is( token._type, 'LEFT_BRACKET', "raw (guard condition)" )
is( token.value, '[' )
lexer:setRawMode()
token = lexer:nextToken()
is( token._type, 'SOURCE' )
is( token.value, 'cond( param1, param2[3], "str\\" ] ing" )' )
token = lexer:nextToken()
is( token._type, 'DONE_SUCCESS' )


lexer = do_parse " func( param1, param2 ) "
token = lexer:nextToken()
is( token._type, 'WORD', "raw2 (param type)" )
is( token.value, 'func' )
token = lexer:nextToken()
is( token._type, 'LEFT_PAREN' )
is( token.value, '(' )
lexer:setRawMode2()
token = lexer:nextToken()
is( token._type, 'SOURCE' )
is( token.value, 'param1' )
token = lexer:nextToken()
is( token._type, 'COMMA' )
is( token.value, ',' )
lexer:setRawMode2()
token = lexer:nextToken()
is( token._type, 'SOURCE' )
is( token.value, 'param2' )
token = lexer:nextToken()
is( token._type, 'RIGHT_PAREN' )
is( token.value, ')' )
token = lexer:nextToken()
is( token._type, 'DONE_SUCCESS' )


lexer = do_parse [===[ func( param1, f2(param3), 'str\' ) ing' ) ]===]
token = lexer:nextToken()
is( token._type, 'WORD', "raw2 (param type)" )
is( token.value, 'func' )
token = lexer:nextToken()
is( token._type, 'LEFT_PAREN' )
is( token.value, '(' )
lexer:setRawMode2()
token = lexer:nextToken()
is( token._type, 'SOURCE' )
is( token.value, 'param1' )
token = lexer:nextToken()
is( token._type, 'COMMA' )
is( token.value, ',' )
lexer:setRawMode2()
token = lexer:nextToken()
is( token._type, 'SOURCE' )
is( token.value, 'f2(param3)' )
token = lexer:nextToken()
is( token._type, 'COMMA' )
is( token.value, ',' )
lexer:setRawMode2()
token = lexer:nextToken()
is( token._type, 'SOURCE' )
is( token.value, "'str\\' ) ing'" )
token = lexer:nextToken()
is( token._type, 'RIGHT_PAREN' )
is( token.value, ')' )
token = lexer:nextToken()
is( token._type, 'DONE_SUCCESS' )


lexer = do_parse " %class   class name  \n"
token = lexer:nextToken()
is( token._type, 'CLASS_NAME', "raw3 (%directive)" )
is( token.value, '%class' )
lexer:setRawMode3()
token = lexer:nextToken()
is( token._type, 'SOURCE' )
is( token.value, 'class name' )
token = lexer:nextToken()
is( token._type, 'DONE_SUCCESS' )


lexer = do_parse " = prop ;"
token = lexer:nextToken()
is( token._type, 'EQUAL', "raw3 (property)" )
is( token.value, '=' )
lexer:setRawMode3()
token = lexer:nextToken()
is( token._type, 'SOURCE' )
is( token.value, 'prop' )
token = lexer:nextToken()
is( token._type, 'DONE_SUCCESS' )


lexer = do_parse [===[

// new comment

word

]===]
token = lexer:nextToken()
is( token._type, 'WORD', "new comment" )
is( token.value, 'word' )
token = lexer:nextToken()
is( token._type, 'DONE_SUCCESS' )


lexer = do_parse [===[

/* old comment */

word1

/*
 * multi / lines
 */

word2

/*
   /* nested old comment */
*/

word3

/*
   // nested new comment
*/

word4

]===]
token = lexer:nextToken()
is( token._type, 'WORD', "old comment" )
is( token.value, 'word1' )
token = lexer:nextToken()
is( token._type, 'WORD' )
is( token.value, 'word2' )
token = lexer:nextToken()
is( token._type, 'WORD' )
is( token.value, 'word3' )
token = lexer:nextToken()
is( token._type, 'WORD' )
is( token.value, 'word4' )
token = lexer:nextToken()
is( token._type, 'DONE_SUCCESS' )

