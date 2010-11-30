
object Guard {
    def main(args: Array[String]) {
        val obj = new Sm.TestClass()
        obj.getFSM().setDebugStream(System.out)
        obj.getFSM().setDebugFlag(args.length > 0)
        obj.Evt1(1)
        obj.Evt1(2)
        obj.Evt1(3)
        obj.Evt_3()
        obj.Evt_2()
        obj.Evt1(1)
    }
}

