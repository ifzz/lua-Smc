
import Sm.*;

public class Default
{
    public static void main(String[] args)
    {
        TestClass obj = new TestClass();
        obj.getFSM().setDebugStream(System.out);
        obj.getFSM().setDebugFlag(args.length > 0);
        obj.Evt1(1);
        obj.Evt2(1);
        obj.Evt1(0);
        obj.Evt1(2);
        obj.Evt2(2);
        obj.Evt3(0);
        obj.Evt3(2);
    }
}
