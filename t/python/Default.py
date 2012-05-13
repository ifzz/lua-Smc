
import sys
import Sm.TestClass

obj = Sm.TestClass.TestClass()
obj._fsm.setDebugStream(sys.stdout)
obj._fsm.setDebugFlag(len(sys.argv) > 1)
obj.Evt1(1)
obj.Evt2(1)
obj.Evt1(0)
obj.Evt1(2)
obj.Evt2(2)
obj.Evt3(0)
obj.Evt3(2)

