
import Sm/TestClassContext

TestClass: class {
    fsm: TestClassContext { get set }
    myProp: Bool { get set }

    init: func () {
        this fsm = TestClassContext new(this)
    }

    NoArg: func {
        "No arg" println()
    }

    Output: func (str: String) {
        str println()
    }

    Output_n: func (str1: String, n: Int, str2: String) {
        "%s%d%s" format(str1, n , str2) println()
    }

    isOk: func -> Bool {
        return true
    }

    isNok: func -> Bool{
        return false
    }

    Evt_1: func {
        fsm Evt_1()
    }

    Evt_2: func {
        fsm Evt_2()
    }

    Evt_3: func {
        fsm Evt_3()
    }

    Evt1: func (n: Int) {
        fsm Evt1(n)
    }

    Evt2: func (n: Int) {
        fsm Evt2(n)
    }

    Evt3: func (n: Int) {
        fsm Evt3(n)
    }
}
