
def obj = new Sm.TestClass()
obj.getFSM().setDebugStream(System.out)
obj.getFSM().setDebugFlag(args.size() > 0)
obj.Evt1(1)
obj.Evt1(2)
obj.Evt1(3)
obj.Evt_3()
obj.Evt_2()
obj.Evt1(1)
