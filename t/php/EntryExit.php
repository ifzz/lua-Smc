
<?php
require_once 'TestClass.php';

$obj = new TestClass();
$obj->Evt_1();
$obj->Evt_2();
$obj->Evt_3();
$obj->Evt_1();
$obj->Evt_2();
$obj->Evt_3();
?>