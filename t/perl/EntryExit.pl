
use strict;
use warnings;

use TestClass;

my $obj = new TestClass();
$obj->Evt_1();
$obj->Evt_2();
$obj->Evt_3();
$obj->Evt_1();
$obj->Evt_2();
$obj->Evt_3();