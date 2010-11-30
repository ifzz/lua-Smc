
<?php

require_once 'TestClassContext.php';

class TestClass {

    protected $_fsm;

    public function __construct() {
        $this->_fsm = new TestClass_sm($this);
        $this->_is_acceptable = false;

        // Uncomment to see debug output.
        //$this->_fsm->setDebugFlag(true);
    }

    public function getFSM() {
        return $this->_fsm;
    }

    public function NoArg() {
        echo "No arg\n";
    }

    public function Output($str) {
        echo "$str\n";
    }

    public function Output_n($str1, $n, $str2) {
        echo "${str1}${n}${str2}\n";
    }

    public function isOk() {
        return true;
    }

    public function isNok() {
        return false;
    }

    public function Evt_1() {
        $this->_fsm->Evt_1();
    }

    public function Evt_2() {
        $this->_fsm->Evt_2();
    }

    public function Evt_3() {
        $this->_fsm->Evt_3();
    }

    public function Evt1($n) {
        $this->_fsm->Evt1($n);
    }

    public function Evt2($n) {
        $this->_fsm->Evt2($n);
    }

    public function Evt3($n) {
        $this->_fsm->Evt3($n);
    }
}
?>
