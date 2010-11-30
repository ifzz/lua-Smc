
def obj = new Sm.TestClass()
obj.getFSM().setDebugStream(System.out)
obj.getFSM().setDebugFlag(args.size() > 0)
obj.Evt_1()
