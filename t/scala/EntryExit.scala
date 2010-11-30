
object EntryExit {
    def main(args: Array[String]) {
        val obj = new Sm.TestClass()
        obj.getFSM().setDebugStream(System.out)
        obj.getFSM().setDebugFlag(args.length > 0)
        obj.Evt_1()
        obj.Evt_2()
        obj.Evt_3()
        obj.Evt_1()
        obj.Evt_2()
        obj.Evt_3()
    }
}
