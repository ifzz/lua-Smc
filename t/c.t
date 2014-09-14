#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin";

use File::Spec::Functions;
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
);

$Util::config = {
    code        => '/* comment */',
    import1     => '',
    import2     => '',
    include1    => '<stdio.h>',
    include2    => '<stdlib.h>',
    is_ok       => 'Sm_TestClass_isOk(ctxt)',
    is_nok      => 'Sm_TestClass_isNok(ctxt)',
    false       => '0',
    n           => 'n',
    param       => 'n: int',
    prop1       => '',
    prop2       => '',
};

my %re = (
    TransUndef  => 'TestClassState_Default',
);

sub test_smc_c {
    my ($test, $options) = @_;
    unlink("t/c/${test}");
    unlink("t/c/${test}.exe");
    unlink("t/c/Sm/TestClass.sm");
    unlink("t/c/Sm/TestClassContext.c");
    unlink("t/c/Sm/TestClassContext.h");
    Util::do_fsm('c/Sm', $test);
    system("${Util::smc} -c ${options} -d t/c/Sm t/c/Sm/TestClass.sm");
    my @gcc = ('gcc', '--std=c90', '-Wall',  '-Wextra', '-Wno-unused-function',  '-Wno-unused-parameter');
    my $out = Util::run(@gcc, "-I runtime/c -I . -o t/c/${test} t/c/${test}.c t/c/Sm/TestClass.c t/c/Sm/TestClassContext.c");
    diag($out) if $out;
    push @gcc, '-DNO_TESTCLASSCONTEXT_MACRO';
    $out = Util::run(@gcc, "-I runtime/c -I . -o t/c/${test} t/c/${test}.c t/c/Sm/TestClass.c t/c/Sm/TestClassContext.c");
    diag($out) if $out;
    my $trace = $options =~ /-g0/ && ${Util::smc} !~ /\.jar/ ? 'g0' : '';
    $out = Util::run(catfile('t', 'c', ${test}), $trace);
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

unless (`gcc --version 2>&1` =~ /^gcc/) {
    plan skip_all => 'no gcc';
}
plan tests => scalar(@Util::tests) * scalar(@opt);
diag($Util::smc);

for my $test (@Util::tests) {
    Util::test_smc_with_options('c/Sm', \&test_smc_c, $test, \@opt);
}

