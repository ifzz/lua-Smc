
LUA     := lua
#LUA     := luajit
SMC     := $(LUA) bin/smc
#SMC     := java -jar Smc.jar
VERSION := $(shell cd src && $(LUA) -e "require [[Smc]]; print(Smc._VERSION)")
TARBALL := lua-smc-$(VERSION).tar.gz
ifndef REV
  REV   := 1
endif

manifest_pl := \
use strict; \
use warnings; \
my @files = qw{MANIFEST}; \
while (<>) { \
    chomp; \
    next if m{^\.}; \
    next if m{/\.}; \
    next if m{^rockspec/}; \
    next if m{\.png}; \
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

install: dist rockspec
	luarocks install rockspec/lua-smc-$(VERSION)-$(REV).rockspec

export LUA_PATH=;;./src/?.lua;./runtime/lua/?.lua;./t/lua/?.lua

check: unit_test

unit_test:
	prove --exec=$(LUA) test/*.t

test:
	prove t/*.t

testclean:
	-rm -f t/lua/*.png t/lua/*.dot t/lua/*.html t/lua/*Context.lua t/lua/*.sm

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

