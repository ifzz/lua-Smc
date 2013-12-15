#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin";

use Test::More;
#use Test::LongString;
use Util;

#$Util::smc = 'java -jar Smc.jar';
#$Util::test_graph = 0;
#$Util::test_table = 0;
#@Util::tests = ( 'Simple' );

my @opt = (
    '',
    '-g0',
    '-g1',
    '-noc',
    '-noc -g0',
    '-noc -g1',
    '-reflect',
);

$Util::config = {
    code        => '// comment',
    import1     => 'http',
    import2     => 'events',
    include1    => 'a',
    include2    => 'b',
    is_ok       => 'ctxt.isOk()',
    is_nok      => 'ctxt.isNok()',
    false       => '0',
    n           => 'n',
    param       => 'n',
    prop1       => 'myProp = 1;',
    prop2       => 'myProp = 0;',
};

my %re = (
    TransUndef  => 'Error: Undefined Transition\nState: (Sm::)?Map_1(::|\.)State_1\nTransition: Evt_1',
);

sub test_smc_perl {
    my ($test, $options) = @_;
    unlink("t/javascript/Sm/TestClass.sm");
    unlink("t/javascript/Sm/TestClassContext.pm");
    Util::do_fsm('javascript/Sm', $test);
    system("${Util::smc} -js ${options} t/javascript/Sm/TestClass.sm");
    my $trace = $options =~ /-g0/ && ${Util::smc} !~ /\.jar/ ? 'g0' : '';
    my $out = Util::run('nodejs', "t/javascript/${test}.js", $trace );
    my $expected = $trace
                 ? Util::slurp("t/templates/${test}.g0.out")
                 : Util::slurp("t/templates/${test}.out");
    if ($expected =~ /^like/) {
        like($out, qr{$re{$test}}, "$test $options");
    }
    else {
        $out =~ s/\$n/n/gm;
        is($out, $expected, "$test $options");
    }
}

my $version = qx{nodejs --version};
unless ($version =~ /^v\d\.\d+\.\d+/) {
    plan skip_all => 'no nodejs';
}
plan tests => scalar(@Util::tests) * scalar(@opt);
diag($version);

for my $test (@Util::tests) {
    Util::test_smc_with_options('javascript/Sm', \&test_smc_perl, $test, \@opt);
}

