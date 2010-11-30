
import sys
import Sm.TestClass

obj = Sm.TestClass.TestClass()
obj._fsm.setDebugStream(sys.stdout)
obj._fsm.setDebugFlag(len(sys.argv) > 1)
obj.Evt_1()
obj.Evt_2() # push
obj.Evt_2() # pop
obj.Evt_2() # push
obj.Evt3(1) # pop
obj.Evt_1()
obj.Evt3(1) # jump
obj.Evt_1() # jump
obj.Evt_1()

