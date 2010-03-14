#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin";

use Test::More;
use Util;

$Util::smc = 'java -jar Smc.jar';
#$Util::test_graph = 0;
#$Util::test_table = 1;
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
    prop1       => 'myProp = True;',
    prop2       => 'myProp = False;',
    param       => 'n',
    ctxt        => 'ctxt.',
    false       => 'False',
};

sub test_smc_scala {
    my ($test, $options) = @_;
    unlink(glob("t/python/*.class"));
    unlink("t/python/TestClass.sm");
    unlink("t/python/TestClassContext.py");
    Util::do_fsm('python', $test);
    system("${Util::smc} -python ${options} t/python/TestClass.sm");
    my $out = Util::run('python', "t/python/${test}.py");
    my $expected = Util::slurp("t/templates/${test}.out");
    is($out, $expected, "$test $options");
}

unless (`python -V 2>&1` =~ /^Python/) {
    plan skip_all => 'no python';
}
plan tests => scalar(@Util::tests) * scalar(@opt);

$ENV{PYTHONPATH} = './runtime/python';

for my $test (@Util::tests) {
    Util::test_smc_with_options('python', \&test_smc_scala, $test, \@opt);
}

