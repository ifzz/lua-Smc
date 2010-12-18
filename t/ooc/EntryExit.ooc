
import structs/ArrayList
import Sm/TestClass

main: func(args: ArrayList<String>) {
    obj := TestClass new()
    obj fsm debugStream = stdout
    obj fsm debugFlag = args getSize() > 1
    obj Evt_1()
    obj Evt_2()
    obj Evt_3()
    obj Evt_1()
    obj Evt_2()
    obj Evt_3()
}

