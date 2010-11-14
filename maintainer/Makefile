
LUA     := lua
SMC     := $(LUA) ../bin/smc
COAT2DOT:= coat2dot

export LUA_PATH=;;../src/?.lua;../runtime/lua/?.lua

all: uml fsm templates

uml: \
    Model.png \
    Parser.png \
    Checker.png \
    Smc.png \
    Languages1.png \
    Languages2.png

fsm: \
    Parser_sm.png \
    Lexer_sm.png

templates: \
    C_template.png \
    C_header_template.png \
    Cpp_template.png \
    Cpp_header_template.png \
    Graphviz_template.png \
    Groovy_template.png \
    Java_template.png \
    Lua_template.png \
    Perl_template.png \
    Php_template.png \
    Python_template.png \
    Ruby_template.png \
    Scala_template.png \
    Table_template.png

clean:
	rm *.dot *.png

Model.dot:
	$(COAT2DOT) --note="Semantic Model" Smc.Model Smc.OperationalModel > $@

Parser.dot:
	$(COAT2DOT) Smc.Parser > $@

Checker.dot:
	$(COAT2DOT) Smc.Checker Smc.Dumper > $@

Smc.dot:
	$(COAT2DOT) --no-attr --no-meth Smc > $@

Languages1.dot:
	$(COAT2DOT) --no-attr Smc.C Smc.Graphviz Smc.Groovy Smc.Lua Smc.Perl Smc.Python Smc.Ruby Smc.Scala > $@

Languages2.dot:
	$(COAT2DOT) --no-attr Smc.Cpp Smc.Csharp Smc.Java Smc.ObjC Smc.Php Smc.Table Smc.Tcl Smc.Vb > $@

C_template.dot: ../src/Smc/C.lua
	$(LUA) -l Smc.C -e "print(require 'CodeGen.Graph'.to_dot(require 'Smc.C.Generator'{srcfileBase='', targetfileBase=''}.template))" > $@

C_header_template.dot: ../src/Smc/C.lua
	$(LUA) -l Smc.C -e "print(require 'CodeGen.Graph'.to_dot(require 'Smc.C.HeaderGenerator'{srcfileBase='', targetfileBase=''}.template))" > $@

Cpp_template.dot: ../src/Smc/Cpp.lua
	$(LUA) -l Smc.Cpp -e "print(require 'CodeGen.Graph'.to_dot(require 'Smc.Cpp.Generator'{srcfileBase='', targetfileBase=''}.template))" > $@

Cpp_header_template.dot: ../src/Smc/Cpp.lua
	$(LUA) -l Smc.Cpp -e "print(require 'CodeGen.Graph'.to_dot(require 'Smc.Cpp.HeaderGenerator'{srcfileBase='', targetfileBase=''}.template))" > $@

Graphviz_template.dot: ../src/Smc/Graphviz.lua
	$(LUA) -l Smc.Graphviz -e "print(require 'CodeGen.Graph'.to_dot(require 'Smc.Graphviz.Generator'{srcfileBase='', targetfileBase=''}.template))" > $@

Groovy_template.dot: ../src/Smc/Groovy.lua
	$(LUA) -l Smc.Groovy -e "print(require 'CodeGen.Graph'.to_dot(require 'Smc.Groovy.Generator'{srcfileBase='', targetfileBase=''}.template))" > $@

Java_template.dot: ../src/Smc/Java.lua
	$(LUA) -l Smc.Java -e "print(require 'CodeGen.Graph'.to_dot(require 'Smc.Java.Generator'{srcfileBase='', targetfileBase=''}.template))" > $@

Lua_template.dot: ../src/Smc/Lua.lua
	$(LUA) -l Smc.Lua -e "print(require 'CodeGen.Graph'.to_dot(require 'Smc.Lua.Generator'{srcfileBase='', targetfileBase=''}.template))" > $@

Perl_template.dot: ../src/Smc/Perl.lua
	$(LUA) -l Smc.Perl -e "print(require 'CodeGen.Graph'.to_dot(require 'Smc.Perl.Generator'{srcfileBase='', targetfileBase=''}.template))" > $@

Php_template.dot: ../src/Smc/Php.lua
	$(LUA) -l Smc.Php -e "print(require 'CodeGen.Graph'.to_dot(require 'Smc.Php.Generator'{srcfileBase='', targetfileBase=''}.template))" > $@

Python_template.dot: ../src/Smc/Python.lua
	$(LUA) -l Smc.Python -e "print(require 'CodeGen.Graph'.to_dot(require 'Smc.Python.Generator'{srcfileBase='', targetfileBase=''}.template))" > $@

Ruby_template.dot: ../src/Smc/Ruby.lua
	$(LUA) -l Smc.Ruby -e "print(require 'CodeGen.Graph'.to_dot(require 'Smc.Ruby.Generator'{srcfileBase='', targetfileBase=''}.template))" > $@

Scala_template.dot: ../src/Smc/Scala.lua
	$(LUA) -l Smc.Scala -e "print(require 'CodeGen.Graph'.to_dot(require 'Smc.Scala.Generator'{srcfileBase='', targetfileBase=''}.template))" > $@

Table_template.dot: ../src/Smc/Table.lua
	$(LUA) -l Smc.Table -e "print(require 'CodeGen.Graph'.to_dot(require 'Smc.Table.Generator'{srcfileBase='', targetfileBase=''}.template))" > $@


%_sm.dot : ../src/Smc/Parser/%.sm
	$(SMC) -graph -glevel 0 -verbose -d ./ $<

%.png : %.dot
	dot -T png -o $@ $<
