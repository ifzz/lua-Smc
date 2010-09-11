
use strict;
use warnings;

use TestClass;

my $obj = new TestClass();
$obj->{_fsm}->setDebugStream(\*STDOUT);
$obj->{_fsm}->setDebugFlag(@ARGV > 0);
$obj->Evt_1();
$obj->Evt_2(); # push
$obj->Evt_2(); # pop
$obj->Evt_2(); # push
$obj->Evt3(1); # pop
$obj->Evt_1();
$obj->Evt3(1); # jump
$obj->Evt_1(); # jump
$obj->Evt_1();
