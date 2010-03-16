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
);

$Util::config = {
    code        => '/* comment */',
    import1     => '',
    import2     => '',
    include1    => '<stdio.h>',
    include2    => '<stdlib.h>',
    is_ok       => 'TestClass_isOk(ctxt)',
    is_nok      => 'TestClass_isNok(ctxt)',
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
    unlink("t/c/TestClass.sm");
    unlink("t/c/TestClassContext.c");
    unlink("t/c/TestClassContext.h");
    Util::do_fsm('c', $test);
    system("${Util::smc} -c ${options} -headerd t/c t/c/TestClass.sm");
    my $out = Util::run('gcc', "-I runtime/c -I . -o t/c/${test} t/c/${test}.c t/c/TestClass.c t/c/TestClassContext.c");
    $out = Util::run("t/c/${test}");
    my $expected = Util::slurp("t/templates/${test}.out");
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

for my $test (@Util::tests) {
    Util::test_smc_with_options('c', \&test_smc_c, $test, \@opt);
}

