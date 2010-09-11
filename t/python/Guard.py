
import sys
import TestClass

obj = TestClass.TestClass()
obj._fsm.setDebugStream(sys.stdout)
obj._fsm.setDebugFlag(len(sys.argv) > 1)
obj.Evt1(1)
obj.Evt1(2)
obj.Evt1(3)
obj.Evt_3()
obj.Evt_2()
obj.Evt1(1)

