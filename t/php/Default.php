
<?php
require_once 'Sm/TestClass.php';

$obj = new TestClass();
$obj->getFSM()->setDebugStream(STDOUT);
$obj->getFSM()->setDebugFlag($argc > 1);
$obj->Evt1(1);
$obj->Evt2(1);
$obj->Evt1(0);
$obj->Evt1(2);
$obj->Evt2(2);
$obj->Evt3(0);
$obj->Evt3(2);
?>
