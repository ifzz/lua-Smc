
import sys
import TestClass

obj = TestClass.TestClass()
obj._fsm.setDebugStream(sys.stdout)
obj._fsm.setDebugFlag(len(sys.argv) > 1)
obj.Evt_1()
obj.Evt_1()
