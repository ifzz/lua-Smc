
import sys
import Sm.TestClass

obj = Sm.TestClass.TestClass()
obj._fsm.setDebugStream(sys.stdout)
obj._fsm.setDebugFlag(len(sys.argv) > 1)
obj.Evt_1()
obj.Evt_2()
obj.Evt_3()
obj.Evt_1()
obj.Evt_2()
obj.Evt_3()

