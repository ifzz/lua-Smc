
local TestClass = require 'TestClass'

local obj = TestClass.new()
obj.fsm.debugStream = require 'io'.stdout
obj.fsm.debugFlag = #arg > 0
obj:Evt_1()
obj:Evt_2()
obj:Evt_3()
obj:Evt_1()
obj:Evt_2()
obj:Evt_3()
