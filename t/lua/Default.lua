
require 'TestClass'

local obj = TestClass:new()
obj._fsm:setDebugStream(require 'io'.stdout)
obj._fsm:setDebugFlag(#arg > 0)
obj:Evt_1()
obj:Evt2(1)
obj:Evt_3()
obj:Evt2(2)
