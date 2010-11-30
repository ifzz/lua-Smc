
package Sm

class TestClass {
    private def _fsm
    boolean myProp

    TestClass () {
        _fsm = new TestClassContext(this)

        // Uncomment to see debug output.
        // _fsm.setDebugFlag(true)
    }

    def getFSM() {
        return _fsm
    }

    def NoArg() {
        println("No arg")
    }

    def Output(String str) {
        println(str)
    }

    def Output_n(String str1, int n, String str2) {
        print(str1)
        print(n)
        println(str2)
    }

    def isOk() {
        return true
    }

    def isNok() {
        return false
    }

    def Evt_1() {
        _fsm.Evt_1()
    }

    def Evt_2() {
        _fsm.Evt_2()
    }

    def Evt_3() {
        _fsm.Evt_3()
    }

    def Evt1(int n) {
        _fsm.Evt1(n)
    }

    def Evt2(int n) {
        _fsm.Evt2(n)
    }

    def Evt3(int n) {
        _fsm.Evt3(n)
    }
}
