
object TransUndef {
    def main(args: Array[String]) {
        val obj = new TestClass()
        obj.getFSM().setDebugStream(System.out)
        obj.getFSM().setDebugFlag(args.length > 0)
        obj.Evt_1()
    }
}

