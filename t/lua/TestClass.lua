
module(..., package.seeall)

function new (self)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    local m = require 'TestClassContext'
    o._fsm = m.TestClassContext:new{_owner = o}
    -- o._fsm:setDebugFlag(true)
    return o
end

function Output (self, ...)
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
