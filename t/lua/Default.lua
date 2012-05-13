
local TestClass = require 'Sm.TestClass'

local obj = TestClass.new()
obj.fsm.debugStream = require 'io'.stdout
obj.fsm.debugFlag = #arg > 0
obj:Evt1(1)
obj:Evt2(1)
obj:Evt1(0)
obj:Evt1(2)
obj:Evt2(2)
obj:Evt3(0)
obj:Evt3(2)
