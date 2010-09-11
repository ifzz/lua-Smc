
def obj = new TestClass()
obj.getFSM().setDebugStream(System.out)
obj.getFSM().setDebugFlag(args.size() > 0)
obj.Evt_1()
obj.Evt_2() // push
obj.Evt_2() // pop
obj.Evt_2() // push
obj.Evt3(1) // pop
obj.Evt_1()
obj.Evt3(1) // jump
obj.Evt_1() // jump
obj.Evt_1()
