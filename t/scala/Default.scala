
object Default {
    def main(args: Array[String]) {
        val obj = new Sm.TestClass()
        obj.getFSM().setDebugStream(System.out)
        obj.getFSM().setDebugFlag(args.length > 0)
        obj.Evt1(1)
        obj.Evt2(1)
        obj.Evt1(0)
        obj.Evt1(2)
        obj.Evt2(2)
        obj.Evt3(0)
        obj.Evt3(2)
    }
}

