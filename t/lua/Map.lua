
require 'TestClass'

local obj = TestClass:new()
obj:Evt_1()
obj:Evt_2() --push
obj:Evt_2() -- pop
obj:Evt_2() -- push
obj:Evt3(1) -- pop
obj:Evt_1()
obj:Evt3(1) -- jump
obj:Evt_1() -- jump
obj:Evt_1()
