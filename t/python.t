#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin";

use Test::More;
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
    code        => '# comment',
    import1     => 'os.path',
    import2     => 'zlib',
    include1    => 'a',
    include2    => 'b',
    is_ok       => 'ctxt.isOk()',
    is_nok      => 'ctxt.isNok()',
    false       => 'False',
    n           => 'n',
    param       => 'n',
    prop1       => 'myProp = True;',
    prop2       => 'myProp = False;',
};

my %re = (
    TransUndef  => 'statemap\.TransitionUndefinedException: \n\tState: Map_1(::|\.)State_1\n\tTransition: Evt_1',
);

sub test_smc_python {
    my ($test, $options) = @_;
    unlink(glob("t/python/*.pyc"));
    unlink("t/python/TestClass.sm");
    unlink("t/python/TestClassContext.py");
    Util::do_fsm('python', $test);
    system("${Util::smc} -python ${options} t/python/TestClass.sm");
    my $trace = $options =~ /-g0/ && ${Util::smc} !~ /\.jar/ ? 'g0' : '';
    my $out = Util::run('python', "t/python/${test}.py", $trace);
    my $expected = $trace
                 ? Util::slurp("t/templates/${test}.g0.out")
                 : Util::slurp("t/templates/${test}.out");
    if ($expected =~ /^like/) {
        like($out, qr{$re{$test}}, "$test $options");
    }
    else {
        is($out, $expected, "$test $options");
    }
}

unless (`python -V 2>&1` =~ /^Python/) {
    plan skip_all => 'no python';
}
plan tests => scalar(@Util::tests) * scalar(@opt);

$ENV{PYTHONPATH} = './runtime/python';

for my $test (@Util::tests) {
    Util::test_smc_with_options('python', \&test_smc_python, $test, \@opt);
}

