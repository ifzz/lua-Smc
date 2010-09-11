
require 'TestClass'

obj = TestClass::new
obj.getFSM().setDebugStream($stdout)
obj.getFSM().setDebugFlag(ARGV.size > 0)
obj.Evt1(1)
obj.Evt1(2)
obj.Evt1(3)
obj.Evt_3()
obj.Evt_2()
obj.Evt1(1)
