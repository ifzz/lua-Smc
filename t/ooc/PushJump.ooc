
import structs/ArrayList
import Sm/TestClass

main: func(args: ArrayList<String>) {
    obj := TestClass new()
    obj fsm debugStream = stdout
    obj fsm debugFlag = args getSize() > 1
    obj Evt_1()
    obj Evt_2() // push
    obj Evt_2() // pop
    obj Evt_2() // push
    obj Evt3(1) // pop
    obj Evt_1()
    obj Evt3(1) // jump
    obj Evt_1() // jump
    obj Evt_1()
}

