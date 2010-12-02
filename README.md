
lua-Smc -- EXPERIMENTAL
=======================

a port on [lua-Coat](http://fperrad.github.com/lua-Coat)

Install
-------

    $ sudo aptitude install lua5.1
    $ sudo aptitude install luarocks
    $ sudo aptitude install graphviz
    $ luarocks install luacov
    $ luarocks install lua-coat
    $ luarocks install lua-codegen
    $ sudo aptitude install libtest-harness-perl        # or cpan Test::Harness
    $ sudo aptitude install libtest-longstring-perl     # or cpan Test::LongString

    $ make install

Delta vs [SMC](http://smc.sourceforge.net/)
-------------------------------------------

### Compiler Command

in the source tree :

    $ bin/smc

after install :

    $ smc

### Command Line Options

- -dump : Ascii output

- -load : Use a language from a plugin

### Language

- %source

### Target Languages Not Currently Supported

- C#
- Objective C
- Tcl
- VB

### Internals

- the code generation uses a template engine ([lua-CodeGen](http://fperrad.github.com/lua-CodeGen))

### Maintainer Documentation

Many graphics built by :

    $ make -C maintainer

Test Suite
----------

    $ make unit_test

    $ make test # for target languages

(work for lua-Smc & SMC)
