
all: smc

clean:
	rm -f *.h
	rm -f smc

bytecodes: codegen.h coat.h coat_meta_class.h coat_types.h coat_file.h \
    statemap.h smc.h smc_generator.h smc_language.h \
    smc_parser.h smc_parser_lexer_sm.h smc_parser_parser_sm.h \
    smc_model.h smc_operationalmodel.h smc_checker.h smc_dumper.h \
    smc_c.h smc_cpp.h smc_groovy.h smc_graphviz.h smc_java.h \
    smc_javascript.h smc_lua.h smc_perl.h smc_php.h \
    smc_python.h smc_ruby.h smc_scala.h smc_table.h

codegen.h: ../../lua-CodeGen-0.3.1/src/CodeGen.lua
	luajit -b $< $@

coat.h: ../../lua-Coat-0.9.1/src/Coat.lua
	luajit -b $< $@

coat_meta_class.h: ../../lua-Coat-0.9.1/src/Coat/Meta/Class.lua
	luajit -b $< $@

coat_types.h: ../../lua-Coat-0.9.1/src/Coat/Types.lua
	luajit -b $< $@

coat_file.h: ../../lua-Coat-0.9.1/src/Coat/file.lua
	luajit -b $< $@

statemap.h: ../runtime/lua/statemap.lua
	luajit -b $< $@

smc.h: ../src/Smc.lua
	luajit -b $< $@

smc_parser.h: ../src/Smc/Parser.lua
	luajit -b $< $@

smc_parser_lexer_sm.h: ../src/Smc/Parser/Lexer_sm.lua
	luajit -b $< $@

smc_parser_parser_sm.h: ../src/Smc/Parser/Parser_sm.lua
	luajit -b $< $@

smc_model.h: ../src/Smc/Model.lua
	luajit -b $< $@

smc_operationalmodel.h: ../src/Smc/OperationalModel.lua
	luajit -b $< $@

smc_checker.h: ../src/Smc/Checker.lua
	luajit -b $< $@

smc_dumper.h: ../src/Smc/Dumper.lua
	luajit -b $< $@

smc_generator.h: ../src/Smc/Generator.lua
	luajit -b $< $@

smc_language.h: ../src/Smc/Language.lua
	luajit -b $< $@

smc_c.h: ../src/Smc/C.lua
	luajit -b $< $@

smc_cpp.h: ../src/Smc/Cpp.lua
	luajit -b $< $@

smc_graphviz.h: ../src/Smc/Graphviz.lua
	luajit -b $< $@

smc_groovy.h: ../src/Smc/Groovy.lua
	luajit -b $< $@

smc_java.h: ../src/Smc/Java.lua
	luajit -b $< $@

smc_javascript.h: ../src/Smc/JavaScript.lua
	luajit -b $< $@

smc_lua.h: ../src/Smc/Lua.lua
	luajit -b $< $@

smc_perl.h: ../src/Smc/Perl.lua
	luajit -b $< $@

smc_php.h: ../src/Smc/Php.lua
	luajit -b $< $@

smc_python.h: ../src/Smc/Python.lua
	luajit -b $< $@

smc_ruby.h: ../src/Smc/Ruby.lua
	luajit -b $< $@

smc_scala.h: ../src/Smc/Scala.lua
	luajit -b $< $@

smc_table.h: ../src/Smc/Table.lua
	luajit -b $< $@

smc: smc.c bytecodes
	gcc -Wall -Wextra -I../../LuaJIT-2.0.3/src -L../../LuaJIT-2.0.3/src $< -lluajit -lm -ldl -o $@
