
<?php
require_once 'TestClass.php';

$obj = new TestClass();
$obj->getFSM()->setDebugStream(STDOUT);
$obj->getFSM()->setDebugFlag($argc > 1);
$obj->Evt_1();
?>
