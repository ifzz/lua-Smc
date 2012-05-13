
require 'TestClass'

obj = Sm::TestClass::new
obj.getFSM().setDebugStream($stdout)
obj.getFSM().setDebugFlag(ARGV.size > 0)
obj.Evt1(1)
obj.Evt2(1)
obj.Evt1(0)
obj.Evt1(2)
obj.Evt2(2)
obj.Evt3(0)
obj.Evt3(2)
