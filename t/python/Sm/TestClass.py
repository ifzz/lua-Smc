
import TestClassContext

class TestClass:

    def __init__(self):
        self._fsm = TestClassContext.TestClass_sm(self)
        # Uncomment to see debug output.
        # self._fsm.setDebugFlag(True)

    def NoArg(self):
        print "No arg"

    def Output(self, s):
        print s

    def Output_n(self, *args):
        print ''.join(map(str,args))

    def isOk(self):
        return True

    def isNok(self):
        return False

    def Evt_1(self):
        self._fsm.Evt_1()

    def Evt_2(self):
        self._fsm.Evt_2()

    def Evt_3(self):
        self._fsm.Evt_3()

    def Evt1(self, n):
        self._fsm.Evt1(n)

    def Evt2(self, n):
        self._fsm.Evt2(n)

    def Evt3(self, n):
        self._fsm.Evt3(n)

