
object Guard {
    def main(args: Array[String]) {
        val obj = new TestClass()
        obj.Evt1(1)
        obj.Evt1(2)
        obj.Evt1(3)
        obj.Evt_3()
        obj.Evt_2()
        obj.Evt1(1)
    }
}

