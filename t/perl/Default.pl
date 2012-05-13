
use strict;
use warnings;

use Sm::TestClass;

my $obj = new Sm::TestClass();
$obj->{_fsm}->setDebugStream(\*STDOUT);
$obj->{_fsm}->setDebugFlag(@ARGV > 0);
$obj->Evt1(1);
$obj->Evt2(1);
$obj->Evt1(0);
$obj->Evt1(2);
$obj->Evt2(2);
$obj->Evt3(0);
$obj->Evt3(2);
