
use strict;
use warnings;

use TestClass;

my $obj = new TestClass();
$obj->{_fsm}->setDebugStream(\*STDOUT);
$obj->{_fsm}->setDebugFlag(@ARGV > 0);
$obj->Evt1(1);
$obj->Evt1(2);
$obj->Evt1(3);
$obj->Evt_3();
$obj->Evt_2();
$obj->Evt1(1);
