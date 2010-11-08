
local print = print
local require = require
local setmetatable = setmetatable
local table = require 'table'

_ENV = nil
local m = {}

function m:new ()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    local m = require 'TestClassContext'
    o._fsm = m.TestClassContext:new{_owner = o}
    -- o._fsm:setDebugFlag(true)
    return o
end

function m:NoArg ()
    print "No arg"
end

function m:Output (str)
    print(str)
end

function m:Output_n (...)
    print(table.concat({...}, ''))
end

function m:isOk ()
    return true
end

function m:isNok ()
    return false
end

function m:Evt_1 ()
    self._fsm:Evt_1()
end

function m:Evt_2 ()
    self._fsm:Evt_2()
end

function m:Evt_3 ()
    self._fsm:Evt_3()
end

function m:Evt1 (...)
    self._fsm:Evt1(...)
end

function m:Evt2 (...)
    self._fsm:Evt2(...)
end

function m:Evt3 (...)
    self._fsm:Evt3(...)
end

return m
