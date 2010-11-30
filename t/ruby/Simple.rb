
require 'TestClass'

obj = Sm::TestClass::new
obj.getFSM().setDebugStream($stdout)
obj.getFSM().setDebugFlag(ARGV.size > 0)
obj.Evt_1()
obj.Evt_1()
