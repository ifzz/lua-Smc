
<?php
require_once 'Sm/TestClass.php';

$obj = new TestClass();
$obj->getFSM()->setDebugStream(STDOUT);
$obj->getFSM()->setDebugFlag($argc > 1);
$obj->Evt_1();
$obj->Evt2(1);
$obj->Evt_3();
$obj->Evt2(2);
?>
