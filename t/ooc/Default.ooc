
import structs/ArrayList
import Sm/TestClass

main: func(args: ArrayList<String>) {
    obj := TestClass new()
    obj fsm debugStream = stdout
    obj fsm debugFlag = args getSize() > 1
    obj Evt1(1)
    obj Evt2(1)
    obj Evt1(0)
    obj Evt1(2)
    obj Evt2(2)
    obj Evt3(0)
    obj Evt3(2)
}

