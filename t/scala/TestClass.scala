
class TestClass() {
    private val _fsm = new TestClassContext(this)
    var myProp: Boolean = false

    // Uncomment to see debug output.
    // _fsm.setDebugFlag(true)

    def NoArg() {
        System.out.println("No arg")
    }

    def Output(str: String) {
        System.out.println(str)
    }

    def Output_n(str1: String, n: Int, str2: String) {
        System.out.print(str1)
        System.out.print(n)
        System.out.println(str2)
    }

    def isOk(): Boolean = {
        return true
    }

    def isNok(): Boolean = {
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

    def Evt1(n: Int) {
        _fsm.Evt1(n)
    }

    def Evt2(n: Int) {
        _fsm.Evt2(n)
    }

    def Evt3(n: Int) {
        _fsm.Evt3(n)
    }

}

