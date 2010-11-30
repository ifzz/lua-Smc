
local TestClass = require 'Sm.TestClass'

local obj = TestClass.new()
obj.fsm.debugStream = require 'io'.stdout
obj.fsm.debugFlag = #arg > 0
obj:Evt_1()
obj:Evt_2() --push
obj:Evt_2() -- pop
obj:Evt_2() -- push
obj:Evt3(1) -- pop
obj:Evt_1()
obj:Evt3(1) -- jump
obj:Evt_1() -- jump
obj:Evt_1()
