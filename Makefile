
LUA     := lua
#LUA     := luajit
SMC     := $(LUA) bin/smc
#SMC     := java -jar Smc.jar
VERSION := $(shell cd src && $(LUA) -e "require [[Smc]]; print(Smc._VERSION)")
TARBALL := lua-smc-$(VERSION).tar.gz
REV     := 1

LUAVER  := 5.1
PREFIX  := /usr/local
DPREFIX := $(DESTDIR)$(PREFIX)
BINDIR  := $(DPREFIX)/bin
LIBDIR  := $(DPREFIX)/share/lua/$(LUAVER)
INSTALL := install

all:
	@echo "Nothing to build here, you can just make install"

install:
	$(INSTALL) -m 755 -D bin/smc                            $(BINDIR)/smc
	$(INSTALL) -m 644 -D src/Smc.lua                        $(LIBDIR)/Smc.lua
	$(INSTALL) -m 644 -D src/Smc/Checker.lua                $(LIBDIR)/Smc/Checker.lua
	$(INSTALL) -m 644 -D src/Smc/Dumper.lua                 $(LIBDIR)/Smc/Dumper.lua
	$(INSTALL) -m 644 -D src/Smc/Generator.lua              $(LIBDIR)/Smc/Generator.lua
	$(INSTALL) -m 644 -D src/Smc/Language.lua               $(LIBDIR)/Smc/Language.lua
	$(INSTALL) -m 644 -D src/Smc/Model.lua                  $(LIBDIR)/Smc/Model.lua
	$(INSTALL) -m 644 -D src/Smc/OperationalModel.lua       $(LIBDIR)/Smc/OperationalModel.lua
	$(INSTALL) -m 644 -D src/Smc/Parser.lua                 $(LIBDIR)/Smc/Parser.lua
	$(INSTALL) -m 644 -D src/Smc/Parser/Lexer_sm.lua        $(LIBDIR)/Smc/Parser/Lexer_sm.lua
	$(INSTALL) -m 644 -D src/Smc/Parser/Parser_sm.lua       $(LIBDIR)/Smc/Parser/Parser_sm.lua
	$(INSTALL) -m 644 -D src/Smc/C.lua                      $(LIBDIR)/Smc/C.lua
	$(INSTALL) -m 644 -D src/Smc/Cpp.lua                    $(LIBDIR)/Smc/Cpp.lua
	#$(INSTALL) -m 644 -D src/Smc/Csharp.lua                 $(LIBDIR)/Smc/Csharp.lua
	$(INSTALL) -m 644 -D src/Smc/Graphviz.lua               $(LIBDIR)/Smc/Graphviz.lua
	$(INSTALL) -m 644 -D src/Smc/Groovy.lua                 $(LIBDIR)/Smc/Groovy.lua
	$(INSTALL) -m 644 -D src/Smc/Java.lua                   $(LIBDIR)/Smc/Java.lua
	$(INSTALL) -m 644 -D src/Smc/Lua.lua                    $(LIBDIR)/Smc/Lua.lua
	#$(INSTALL) -m 644 -D src/Smc/ObjC.lua                   $(LIBDIR)/Smc/ObjC.lua
	#$(INSTALL) -m 644 -D src/Smc/Ooc.lua                    $(LIBDIR)/Smc/Ooc.lua
	$(INSTALL) -m 644 -D src/Smc/Perl.lua                   $(LIBDIR)/Smc/Perl.lua
	$(INSTALL) -m 644 -D src/Smc/Php.lua                    $(LIBDIR)/Smc/Php.lua
	$(INSTALL) -m 644 -D src/Smc/Python.lua                 $(LIBDIR)/Smc/Python.lua
	$(INSTALL) -m 644 -D src/Smc/Ruby.lua                   $(LIBDIR)/Smc/Ruby.lua
	$(INSTALL) -m 644 -D src/Smc/Scala.lua                  $(LIBDIR)/Smc/Scala.lua
	$(INSTALL) -m 644 -D src/Smc/Table.lua                  $(LIBDIR)/Smc/Table.lua
	#$(INSTALL) -m 644 -D src/Smc/Tcl.lua                    $(LIBDIR)/Smc/Tcl.lua
	#$(INSTALL) -m 644 -D src/Smc/Vb.lua                     $(LIBDIR)/Smc/Vb.lua
	$(INSTALL) -m 644 -D runtime/lua/statemap.lua           $(LIBDIR)/statemap.lua

uninstall:
	rm -f $(BINDIR)/coat2dot
	rm -f $(LIBDIR)/Coat.lua
	rm -f $(LIBDIR)/Coat/Role.lua
	rm -f $(LIBDIR)/Coat/Types.lua
	rm -f $(LIBDIR)/Coat/UML.lua
	rm -f $(LIBDIR)/Coat/file.lua
	rm -f $(LIBDIR)/Coat/Meta/Class.lua
	rm -f $(LIBDIR)/Coat/Meta/Role.lua

manifest_pl := \
use strict; \
use warnings; \
my @files = qw{MANIFEST}; \
while (<>) { \
    chomp; \
    next if m{^\.}; \
    next if m{/\.}; \
    next if m{^maintainer/}; \
    next if m{^rockspec/}; \
    next if m{^t/}; \
    next if m{^runtime/} && !m{^runtime/lua}; \
    next if m{\.png}; \
    next if m{\.exe}; \
    push @files, $$_; \
} \
print join qq{\n}, sort @files;

rockspec_pl := \
use strict; \
use warnings; \
use Digest::MD5; \
open my $$FH, q{<}, q{$(TARBALL)} \
    or die qq{Cannot open $(TARBALL) ($$!)}; \
binmode $$FH; \
my %config = ( \
    version => q{$(VERSION)}, \
    rev     => q{$(REV)}, \
    md5     => Digest::MD5->new->addfile($$FH)->hexdigest(), \
); \
close $$FH; \
while (<>) { \
    s{@(\w+)@}{$$config{$$1}}g; \
    print; \
}

version:
	@echo $(VERSION)

CHANGES:
	perl -i.bak -pe "s{^$(VERSION).*}{q{$(VERSION)  }.localtime()}e" CHANGES

tag:
	git tag -a -m 'tag release $(VERSION)' $(VERSION)

MANIFEST:
	git ls-files | perl -e '$(manifest_pl)' > MANIFEST

$(TARBALL): MANIFEST
	[ -d lua-Smc-$(VERSION) ] || ln -s . lua-Smc-$(VERSION)
	perl -ne 'print qq{lua-Smc-$(VERSION)/$$_};' MANIFEST | \
	    tar -zc -T - -f $(TARBALL)
	rm lua-Smc-$(VERSION)

dist: $(TARBALL)

rockspec: $(TARBALL)
	perl -e '$(rockspec_pl)' rockspec.in > rockspec/lua-smc-$(VERSION)-$(REV).rockspec

rock:
	luarocks pack rockspec/lua-smc-$(VERSION)-$(REV).rockspec

export LUA_PATH=;;./src/?.lua;./runtime/lua/?.lua;./t/lua/?.lua

check: unit_test

unit_test:
	prove --exec=$(LUA) test/*.t

test:
	prove t/*.t

testclean:
	-rm -f t/lua/*.png t/lua/*.dot t/lua/*.html t/lua/*Context.lua t/lua/*.sm

luacheck:
	luacheck --codes --no-global src --ignore 211/tostring --ignore 212/self --ignore 212/token --ignore 542
	luacheck --no-global test/*.t

coverage:
	rm -f luacov.stats.out luacov.report.out
	prove --exec="$(LUA) -lluacov" test/*.t
#	prove t/*.t
	luacov

bootstrap:
	$(SMC) -lua -nocatch -g -verbose src/Smc/Parser/Lexer.sm
	$(SMC) -lua -nocatch -g -verbose src/Smc/Parser/Parser.sm

cleangen:
	-rm src/Smc/Parser/*_sm.lua

regen: cleangen src/Smc/Parser/Parser_sm.lua src/Smc/Parser/Lexer_sm.lua

%_sm.lua: %.sm
	java -jar Smc.jar -lua -nocatch -g $<

README.html: README.md
	Markdown.pl README.md > README.html

clean: testclean
	make -C maintainer clean
	-rm -f MANIFEST *.bak README.html

.PHONY: test rockspec CHANGES

