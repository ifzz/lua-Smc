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
    '-access public',
#    '-access private',
#    '-access protected',
    '-access package',
    '-generic',
    '-reflect',
    '-reflect -generic',
    '-serial',
    '-sync',
    '-reflect -generic -serial -sync',
    '-g0 -reflect -generic -serial -sync',
    '-g1 -reflect -generic -serial -sync',
    '-noc -reflect -generic -serial -sync',
    '-noc -g0 -reflect -generic -serial -sync',
    '-noc -g1 -reflect -generic -serial -sync',
);

$Util::config = {
    code        => '// comment',
    import1     => 'java.io.*',
    import2     => 'java.net.*',
    include1    => 'a',
    include2    => 'b',
    is_ok       => 'ctxt.isOk()',
    is_nok      => 'ctxt.isNok()',
    false       => 'false',
    n           => 'n',
    param       => 'n: int',
    prop1       => '',
    prop2       => '',
};

my %re = (
    TransUndef  => 'statemap\.TransitionUndefinedException: State: Map_1(::|\.)State_1, Transition: Evt_1',
);

sub test_smc_java {
    my ($test, $options) = @_;
    unlink(glob("t/java/*.class"));
    unlink("t/java/TestClass.sm");
    unlink("t/java/TestClassContext.java");
    Util::do_fsm('java', $test);
    system("${Util::smc} -java ${options} t/java/TestClass.sm");
    my $out = Util::run('cd t/java && javac -g -Xlint:unchecked -classpath ../../runtime/java/statemap.jar TestClass.java TestClassContext.java', "${test}.java");
    $out = Util::run('java -classpath t/java:runtime/java/statemap.jar', $test);
    my $expected = Util::slurp("t/templates/${test}.out");
    if ($expected =~ /^like/) {
        like($out, qr{$re{$test}}, "$test $options");
    }
    else {
        is($out, $expected, "$test $options");
    }
}

unless (`javac -version 2>&1` =~ /^javac/) {
    plan skip_all => 'no javac';
}
plan tests => scalar(@Util::tests) * scalar(@opt);

for my $test (@Util::tests) {
    Util::test_smc_with_options('java', \&test_smc_java, $test, \@opt);
}

