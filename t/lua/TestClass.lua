
local print = print
local require = require
local setmetatable = setmetatable
local table = require 'table'

module(...)

function new (self)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    local m = require 'TestClassContext'
    o._fsm = m.TestClassContext:new{_owner = o}
    -- o._fsm:setDebugFlag(true)
    return o
end

function NoArg (self)
    print "No arg"
end

function Output (self, str)
    print(str)
end

function Output_n (self, ...)
    print(table.concat({...}, ''))
end

function isOk (self)
    return true
end

function isNok (self)
    return false
end

function Evt_1 (self)
    self._fsm:Evt_1()
end

function Evt_2 (self)
    self._fsm:Evt_2()
end

function Evt_3 (self)
    self._fsm:Evt_3()
end

function Evt1 (self, ...)
    self._fsm:Evt1(...)
end

function Evt2 (self, ...)
    self._fsm:Evt2(...)
end

function Evt3 (self, ...)
    self._fsm:Evt3(...)
end
