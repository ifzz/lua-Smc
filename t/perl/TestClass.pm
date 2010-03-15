
use strict;
use warnings;

use TestClassContext;

package TestClass;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = {};
    bless($self, $class);
    $self->{_fsm} = new TestClass_sm($self);

    # Uncomment to see debug output.
    #$self->{_fsm}->setDebugFlag(1);

    return $self;
}

sub Output {
    my $self = shift;
    print shift, "\n";
}

sub Output_n {
    my $self = shift;
    print join('', @_), "\n";
}

sub isOk {
    my $self = shift;
    return 1;
}

sub isNok {
    my $self = shift;
    return 0;
}

sub Evt_1 {
    my $self = shift;
    $self->{_fsm}->Evt_1();
}

sub Evt_2 {
    my $self = shift;
    $self->{_fsm}->Evt_2();
}

sub Evt_3 {
    my $self = shift;
    $self->{_fsm}->Evt_3();
}

sub Evt1 {
    my $self = shift;
    $self->{_fsm}->Evt1(@_);
}

sub Evt2 {
    my $self = shift;
    $self->{_fsm}->Evt2(@_);
}

sub Evt3 {
    my $self = shift;
    $self->{_fsm}->Evt3(@_);
}

1;