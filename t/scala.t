#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin";

use Test::More;
use Util;

#$Util::smc = 'java -jar Smc.jar';
#$Util::test_graph = 0;
#$Util::test_table = 1;
#@Util::tests = ( 'Map' );
@Util::tests = qw(
    Simple
    EntryExit
    Guard
    Default
);

my @opt = (
    '',
    '-g0',
    '-g1',
    '-noc',
    '-noc -g0',
    '-noc -g1',
    '-reflect',
    '-serial',
    '-sync',
);

$Util::config = {
    code        => '// comment',
    import1     => 'java.io._',
    import2     => 'java.net._',
    prop        => 'myProp = false;',
    param       => 'n: Int',
    ctxt        => 'ctxt.',
};

sub test_smc_scala {
    my ($test, $options) = @_;
    unlink(glob("t/scala/*.class"));
    unlink("t/scala/TestClass.sm");
    unlink("t/scala/TestClassContext.scala");
    Util::do_fsm('scala', $test);
    system("${Util::smc} -scala ${options} t/scala/TestClass.sm");
    my $out = Util::run('cd t/scala && scalac -g ../../runtime/scala/statemap.scala TestClass.scala TestClassContext.scala', "${test}.scala");
    $out = Util::run('scala -classpath t/scala', $test);
    my $expected = Util::slurp("t/templates/${test}.out");
    is($out, $expected, "$test $options");
}

unless (`scalac -version 2>&1` =~ /^Scala/) {
    plan skip_all => 'no scala';
}
plan tests => scalar(@Util::tests) * scalar(@opt);

for my $test (@Util::tests) {
    Util::test_smc_with_options('scala', \&test_smc_scala, $test, \@opt);
}

