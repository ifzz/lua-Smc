
source ./runtime/tcl/statemap.tcl;
source ./t/tcl/TestClassContext.tcl;

class TestClass {
    private variable _fsm;

    constructor {} {
        set _fsm [TestClassContext #auto $this];

        # Uncomment to see debug output;
        # $_fsm setDebugFlag 1;
    }

    public method NoArg {} {
         puts "No arg"
    }

    public method Output {str} {
         puts $str
    }

    public method Output_n {str1 n str2} {
        puts $str1 $n $str2
    }

    public method isOk {} {
        return -code ok 1;
    }

    public method isNok {} {
        return -code ok 0;
    }

    public method Evt_1 {} {
        $_fsm Evt_1;
    }

    public method Evt_2 {} {
        $_fsm Evt_2;
    }

    public method Evt_3 {} {
        $_fsm Evt_3;
    }

    public method Evt1 {n} {
        $_fsm Evt_1 $n;
    }

    public method Evt2 {n} {
        $_fsm Evt_2 $n;
    }

    public method Evt3 {n} {
        $_fsm Evt_3 $n;
    }
}
