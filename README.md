
lua-Smc
=======

[![Build Status](https://travis-ci.org/fperrad/lua-Smc.png)](https://travis-ci.org/fperrad/lua-Smc)

a port on [lua-Coat](http://fperrad.github.com/lua-Coat)

Delta vs [SMC](http://smc.sourceforge.net/)
-------------------------------------------

### Install

with [luarocks](http://luarocks.org/)

    $ luarocks install lua-smc

### Compiler Command

in the source tree :

    $ bin/smc

after install :

    $ smc

### Windows binary

a standalone executable for Windows ([LuaJIT](http://luajit.org/) based) is available :
[smc.exe](https://github.com/fperrad/lua-Smc/blob/master/src_c/win/smc.exe)

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
