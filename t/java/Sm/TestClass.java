
package Sm;

public class TestClass
{
    private TestClassContext _fsm;

    public TestClass()
    {
        _fsm = new TestClassContext(this);

        // Uncomment to see debug output.
        // _fsm.setDebugFlag(true);
    }

    public statemap.FSMContext getFSM() {
        return _fsm;
    }

    public void NoArg() {
        System.out.println("No arg");
    }

    public void Output(String str) {
        System.out.println(str);
    }

    public void Output_n(String str1, int n, String str2) {
        System.out.print(str1);
        System.out.print(n);
        System.out.println(str2);
    }

    public boolean isOk() {
        return true;
    }

    public boolean isNok() {
        return false;
    }

    public void Evt_1() {
        _fsm.Evt_1();
    }

    public void Evt_2() {
        _fsm.Evt_2();
    }

    public void Evt_3() {
        _fsm.Evt_3();
    }

    public void Evt1(int n) {
        _fsm.Evt1(n);
    }

    public void Evt2(int n) {
        _fsm.Evt2(n);
    }

    public void Evt3(int n) {
        _fsm.Evt3(n);
    }

}
