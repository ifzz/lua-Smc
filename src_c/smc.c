/*
** Smc frontend.
** Copyright (C) 2014 Francois Perrad.
**
** Major portions taken verbatim or adapted from the LuaJIT interpreter.
** Copyright (C) 2005-2014 Mike Pall. See Copyright Notice in luajit.h
**
** Major portions taken verbatim or adapted from the Lua interpreter.
** Copyright (C) 1994-2008 Lua.org, PUC-Rio. See Copyright Notice in lua.h
*/

#include <stdlib.h>
#include <string.h>
#include <signal.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
#include "luajit.h"

#include "coat.h"
#include "coat_meta_class.h"
#include "coat_types.h"
#include "coat_file.h"
#include "codegen.h"
#include "statemap.h"
#include "smc.h"
#include "smc_checker.h"
#include "smc_dumper.h"
#include "smc_generator.h"
#include "smc_model.h"
#include "smc_operationalmodel.h"
#include "smc_parser.h"
#include "smc_parser_lexer_sm.h"
#include "smc_parser_parser_sm.h"
#include "smc_language.h"
#include "smc_c.h"
#include "smc_cpp.h"
#include "smc_graphviz.h"
#include "smc_groovy.h"
#include "smc_java.h"
#include "smc_javascript.h"
#include "smc_lua.h"
#include "smc_perl.h"
#include "smc_php.h"
#include "smc_python.h"
#include "smc_ruby.h"
#include "smc_scala.h"
#include "smc_table.h"

static lua_State *globalL = NULL;
static const char *progname = "smc";

static void lstop(lua_State *L, lua_Debug *ar)
{
  (void)ar;  /* unused arg. */
  lua_sethook(L, NULL, 0, 0);
  /* Avoid luaL_error -- a C hook doesn't add an extra frame. */
  luaL_where(L, 0);
  lua_pushfstring(L, "%sinterrupted!", lua_tostring(L, -1));
  lua_error(L);
}

static void laction(int i)
{
  signal(i, SIG_DFL); /* if another SIGINT happens before lstop,
                         terminate process (default action) */
  lua_sethook(globalL, lstop, LUA_MASKCALL | LUA_MASKRET | LUA_MASKCOUNT, 1);
}

static void l_message(const char *pname, const char *msg)
{
  if (pname) fprintf(stderr, "%s: ", pname);
  fprintf(stderr, "%s\n", msg);
  fflush(stderr);
}

static int report(lua_State *L, int status)
{
  if (status && !lua_isnil(L, -1)) {
    const char *msg = lua_tostring(L, -1);
    if (msg == NULL) msg = "(error object is not a string)";
    l_message(progname, msg);
    lua_pop(L, 1);
  }
  return status;
}

static int traceback(lua_State *L)
{
  if (!lua_isstring(L, 1)) { /* Non-string error object? Try metamethod. */
    if (lua_isnoneornil(L, 1) ||
        !luaL_callmeta(L, 1, "__tostring") ||
        !lua_isstring(L, -1))
      return 1;  /* Return non-string error object. */
    lua_remove(L, 1);  /* Replace object by result of __tostring metamethod. */
  }
  luaL_traceback(L, L, lua_tostring(L, 1), 1);
  return 1;
}

static int docall(lua_State *L, int narg, int clear)
{
  int status;
  int base = lua_gettop(L) - narg;  /* function index */
  lua_pushcfunction(L, traceback);  /* push traceback function */
  lua_insert(L, base);  /* put it under chunk and args */
  signal(SIGINT, laction);
  status = lua_pcall(L, narg, (clear ? 0 : LUA_MULTRET), base);
  signal(SIGINT, SIG_DFL);
  lua_remove(L, base);  /* remove traceback function */
  /* force a complete garbage collection in case of errors */
  if (status != 0) lua_gc(L, LUA_GCCOLLECT, 0);
  return status;
}

static int getargs(lua_State *L, char **argv, int n)
{
  int narg;
  int i;
  int argc = 0;
  while (argv[argc]) argc++;  /* count total number of arguments */
  narg = argc - (n + 1);  /* number of arguments to the script */
  luaL_checkstack(L, narg + 3, "too many arguments to script");
  for (i = n+1; i < argc; i++)
    lua_pushstring(L, argv[i]);
  lua_createtable(L, narg, n + 1);
  for (i = 0; i < argc; i++) {
    lua_pushstring(L, argv[i]);
    lua_rawseti(L, -2, i - n);
  }
  return narg;
}

static struct Sbytecode {
  const char *name;
  const char *buff;
  size_t sz;
} sbytecodes [] = {
  { "CodeGen",              luaJIT_BC_CodeGen,          luaJIT_BC_CodeGen_SIZE },
  { "Coat",                 luaJIT_BC_Coat,             luaJIT_BC_Coat_SIZE },
  { "Coat.Meta.Class",      luaJIT_BC_Class,            luaJIT_BC_Class_SIZE },
  { "Coat.Types",           luaJIT_BC_Types,            luaJIT_BC_Types_SIZE },
  { "Coat.file",            luaJIT_BC_file,             luaJIT_BC_file_SIZE },
  { "statemap",             luaJIT_BC_statemap,         luaJIT_BC_statemap_SIZE },
  { "Smc",                  luaJIT_BC_Smc,              luaJIT_BC_Smc_SIZE },
  { "Smc.Parser",           luaJIT_BC_Parser,           luaJIT_BC_Parser_SIZE },
  { "Smc.Parser.Lexer_sm",  luaJIT_BC_Lexer_sm,         luaJIT_BC_Lexer_sm_SIZE },
  { "Smc.Parser.Parser_sm", luaJIT_BC_Parser_sm,        luaJIT_BC_Parser_sm_SIZE },
  { "Smc.Model",            luaJIT_BC_Model,            luaJIT_BC_Model_SIZE },
  { "Smc.OperationalModel", luaJIT_BC_OperationalModel, luaJIT_BC_OperationalModel_SIZE },
  { "Smc.Checker",          luaJIT_BC_Checker,          luaJIT_BC_Checker_SIZE },
  { "Smc.Dumper",           luaJIT_BC_Dumper,           luaJIT_BC_Dumper_SIZE },
  { "Smc.Generator",        luaJIT_BC_Generator,        luaJIT_BC_Generator_SIZE },
  { "Smc.Language",         luaJIT_BC_Language,         luaJIT_BC_Language_SIZE },
  { "Smc.C",                luaJIT_BC_C,                luaJIT_BC_C_SIZE },
  { "Smc.Cpp",              luaJIT_BC_Cpp,              luaJIT_BC_Cpp_SIZE },
  { "Smc.Graphviz",         luaJIT_BC_Graphviz,         luaJIT_BC_Graphviz_SIZE },
  { "Smc.Groovy",           luaJIT_BC_Groovy,           luaJIT_BC_Groovy_SIZE },
  { "Smc.Java",             luaJIT_BC_Java,             luaJIT_BC_Java_SIZE },
  { "Smc.JavaScript",       luaJIT_BC_JavaScript,       luaJIT_BC_JavaScript_SIZE },
  { "Smc.Lua",              luaJIT_BC_Lua,              luaJIT_BC_Lua_SIZE },
  { "Smc.Perl",             luaJIT_BC_Perl,             luaJIT_BC_Perl_SIZE },
  { "Smc.Php",              luaJIT_BC_Php,              luaJIT_BC_Php_SIZE },
  { "Smc.Python",           luaJIT_BC_Python,           luaJIT_BC_Python_SIZE },
  { "Smc.Ruby",             luaJIT_BC_Ruby,             luaJIT_BC_Ruby_SIZE },
  { "Smc.Scala",            luaJIT_BC_Scala,            luaJIT_BC_Scala_SIZE },
  { "Smc.Table",            luaJIT_BC_Table,            luaJIT_BC_Table_SIZE },
  { NULL,                   NULL,                       0 }
};

static const char script[] = "require 'Smc'; Smc.instance():main(arg)";

static struct Smain {
  char **argv;
  int argc;
  int status;
} smain;

static int pmain(lua_State *L)
{
  struct Smain *s = &smain;
  char **argv = s->argv;
  globalL = L;
  struct Sbytecode *pBC = &sbytecodes[0];
  if (argv[0] && argv[0][0]) progname = argv[0];
  lua_gc(L, LUA_GCSTOP, 0);  /* stop collector during initialization */
  luaL_openlibs(L);  /* open libraries */
  lua_gc(L, LUA_GCRESTART, -1);
  (void)getargs(L, argv, 0);  /* collect arguments */
  lua_setglobal(L, "arg");
  lua_getglobal(L, "package");
  lua_getfield(L, -1, "preload"); /* package.preload */
  while (pBC->name != NULL) {
    (void)luaL_loadbufferx(L, pBC->buff, pBC->sz, pBC->name, "b");
    lua_setfield(L, -2, pBC->name);
    pBC++;
  }
  lua_pop(L, 2); /* remove package & package.preload */
  s->status = report(L, luaL_loadbuffer(L, script, strlen(script), "main") || docall(L, 0, 1));
  return 0;
}

int main(int argc, char **argv)
{
  int status;
  lua_State *L = lua_open();  /* create state */
  if (L == NULL) {
    l_message(argv[0], "cannot create state: not enough memory");
    return EXIT_FAILURE;
  }
  smain.argc = argc;
  smain.argv = argv;
  status = lua_cpcall(L, pmain, NULL);
  report(L, status);
  lua_close(L);
  return (status || smain.status) ? EXIT_FAILURE : EXIT_SUCCESS;
}

