
object EntryExit {
    def main(args: Array[String]) {
        val obj = new TestClass()
        obj.Evt_1()
        obj.Evt_2()
        obj.Evt_3()
        obj.Evt_1()
        obj.Evt_2()
        obj.Evt_3()
    }
}
