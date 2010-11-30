
import Sm.*;

public class Simple
{
    public static void main(String[] args)
    {
        TestClass obj = new TestClass();
        obj.getFSM().setDebugStream(System.out);
        obj.getFSM().setDebugFlag(args.length > 0);
        obj.Evt_1();
        obj.Evt_1();
    }
}
