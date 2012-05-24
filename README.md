
lua-Smc -- EXPERIMENTAL
=======================

a port on [lua-Coat](http://fperrad.github.com/lua-Coat)

Install
-------

    $ sudo apt-get install lua5.1
    $ sudo apt-get install luarocks
    $ sudo apt-get install graphviz
    $ sudo luarocks install luacov
    $ sudo luarocks install lua-coat
    $ sudo luarocks install lua-codegen
    $ sudo apt-get install libtest-harness-perl        # or cpan Test::Harness
    $ sudo apt-get install libtest-longstring-perl     # or cpan Test::LongString

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

- %source _filename_ : inclusion directive, allows to split a FSM definition into multiple files

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
