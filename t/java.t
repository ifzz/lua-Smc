#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin";

use Test::More;
use Test::LongString;
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
    TransUndef  => 'statemap\.TransitionUndefinedException: State: (Sm::)?Map_1(::|\.)State_1, Transition: Evt_1',
);

sub test_smc_java {
    my ($test, $options) = @_;
    unlink(glob("t/java/*.class"));
    unlink(glob("t/java/Sm/*.class"));
    unlink("t/java/Sm/TestClass.sm");
    unlink("t/java/Sm/TestClassContext.java");
    Util::do_fsm('java/Sm', $test);
    system("${Util::smc} -java ${options} t/java/Sm/TestClass.sm");
    my $lint = $options =~ /-generic/ ? '-Xlint:unchecked' : '';
    my $out = Util::run("cd t/java && javac -g $lint -classpath ../../runtime/java/statemap.jar Sm/TestClass.java Sm/TestClassContext.java", "${test}.java");
    diag($out) if $out;
    my $trace = $options =~ /-g0/ && ${Util::smc} !~ /\.jar/ ? 'g0' : '';
    $out = Util::run('java -classpath t/java:runtime/java/statemap.jar', $test, $trace);
    my $expected = $trace
                 ? Util::slurp("t/templates/${test}.g0.out")
                 : Util::slurp("t/templates/${test}.out");
    if ($expected =~ /^like/) {
        like_string($out, qr{$re{$test}}, "$test $options");
    }
    else {
        $out =~ s/int n/n/gm;
        is_string($out, $expected, "$test $options");
    }
}

unless (`javac -version 2>&1` =~ /^javac/) {
    plan skip_all => 'no javac';
}
plan tests => scalar(@Util::tests) * scalar(@opt);

for my $test (@Util::tests) {
    Util::test_smc_with_options('java/Sm', \&test_smc_java, $test, \@opt);
}

