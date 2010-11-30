
import sys
import Sm.TestClass

obj = Sm.TestClass.TestClass()
obj._fsm.setDebugStream(sys.stdout)
obj._fsm.setDebugFlag(len(sys.argv) > 1)
obj.Evt_1()
obj.Evt2(1)
obj.Evt_3()
obj.Evt2(2)

