
use strict;
use warnings;

use Sm::TestClass;

my $obj = new Sm::TestClass();
$obj->{_fsm}->setDebugStream(\*STDOUT);
$obj->{_fsm}->setDebugFlag(@ARGV > 0);
$obj->Evt_1();
$obj->Evt2(1);
$obj->Evt_3();
$obj->Evt2(2);
