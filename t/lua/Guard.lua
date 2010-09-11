
require 'TestClass'

local obj = TestClass:new()
obj._fsm:setDebugStream(require 'io'.stdout)
obj._fsm:setDebugFlag(#arg > 0)
obj:Evt1(1)
obj:Evt1(2)
obj:Evt1(3)
obj:Evt_3()
obj:Evt_2()
obj:Evt1(1)
