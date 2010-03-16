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
#    '-noexcept',
#    '-nostream',
    '-serial',
    '-cast dynamic_cast',
    '-cast static_cast',
    '-cast reinterpret_cast',
);

$Util::config = {
    code        => '// comment ',
    import1     => 'statemap',
    import2     => 'statemap',
    include1    => '<stdio.h>',
    include2    => '<stdlib.h>',
    is_ok       => 'ctxt.isOk()',
    is_nok      => 'ctxt.isNok()',
    false       => '0',
    n           => 'n',
    param       => 'n: int',
    prop1       => '',
    prop2       => '',
};

my %re = (
    TransUndef  => 'statemap::TransitionUndefinedException',
);

sub test_smc_cpp {
    my ($test, $options) = @_;
    unlink("t/c++/${test}");
    unlink("t/c++/TestClass.sm");
    unlink("t/c++/TestClassContext.cpp");
    unlink("t/c++/TestClassContext.h");
    Util::do_fsm('c++', $test);
    system("${Util::smc} -c++ ${options} -headerd t/c++ t/c++/TestClass.sm");
    my $out = Util::run('g++', "-I runtime/c++ -I . -o t/c++/${test} t/c++/${test}.cpp t/c++/TestClass.cpp t/c++/TestClassContext.cpp");
    $out = Util::run("t/c++/${test}");
    my $expected = Util::slurp("t/templates/${test}.out");
    if ($expected =~ /^like/) {
        like($out, qr{$re{$test}}, "$test $options");
    }
    else {
        is($out, $expected, "$test $options");
    }
}

unless (`g++ --version 2>&1` =~ /^g++/) {
    plan skip_all => 'no g++';
}
plan tests => scalar(@Util::tests) * scalar(@opt);

for my $test (@Util::tests) {
    Util::test_smc_with_options('c++', \&test_smc_cpp, $test, \@opt);
}

