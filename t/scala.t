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
    '-serial',
    '-sync',
);

$Util::config = {
    code        => '// comment',
    import1     => 'java.io._',
    import2     => 'java.net._',
    include1    => 'a',
    include2    => 'b',
    is_ok       => 'ctxt.isOk()',
    is_nok      => 'ctxt.isNok()',
    false       => 'false',
    n           => 'n',
    param       => 'n: Int',
    prop1       => 'myProp = true;',
    prop2       => 'myProp = false;',
};

my %re = (
    TransUndef  => 'statemap\.TransitionUndefinedException: State: (Sm::)?Map_1(::|\.)State_1, Transition: Evt_1',
);

sub test_smc_scala {
    my ($test, $options) = @_;
    unlink(glob("t/scala/*.class"));
    unlink(glob("t/scala/Sm/*.class"));
    unlink("t/scala/Sm/TestClass.sm");
    unlink("t/scala/Sm/TestClassContext.scala");
    Util::do_fsm('scala/Sm', $test);
    system("${Util::smc} -scala ${options} t/scala/Sm/TestClass.sm");
    my $out = Util::run('cd t/scala && scalac -g ../../runtime/scala/statemap.scala Sm/TestClass.scala Sm/TestClassContext.scala', "${test}.scala");
    diag($out) if $out;
    my $trace = $options =~ /-g0/ && ${Util::smc} !~ /\.jar/ ? 'g0' : '';
    $out = Util::run('scala -classpath t/scala', $test, $trace);
    my $expected = $trace
                 ? Util::slurp("t/templates/${test}.g0.out")
                 : Util::slurp("t/templates/${test}.out");
    if ($expected =~ /^like/) {
        like($out, qr{$re{$test}}, "$test $options");
    }
    else {
        $out =~ s/n: Int/n/gm;
        is($out, $expected, "$test $options");
    }
}

unless (`scalac -version 2>&1` =~ /^Scala/) {
    plan skip_all => 'no scala';
}
plan tests => scalar(@Util::tests) * scalar(@opt);

for my $test (@Util::tests) {
    Util::test_smc_with_options('scala/Sm', \&test_smc_scala, $test, \@opt);
}

