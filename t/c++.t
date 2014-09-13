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
    '-noc',
    '-noc -g0',
    '-noc -g1',
    '-nostream -g1',
    '-serial',
    '-noexcept',
    '-noexcept -g0',
    '-noexcept -g1',
    '-noexcept -nostream -g0',
    '-noexcept -serial',
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
    TransUndef  => '(statemap::TransitionUndefinedException|Assertion)',
);

sub test_smc_cpp {
    my ($test, $options) = @_;
    unlink("t/c++/${test}");
    unlink("t/c++/${test}.exe");
    unlink("t/c++/Sm/TestClass.sm");
    unlink("t/c++/Sm/TestClassContext.cpp");
    unlink("t/c++/Sm/TestClassContext.h");
    Util::do_fsm('c++/Sm', $test);
    system("${Util::smc} -c++ ${options} -d t/c++/Sm t/c++/Sm/TestClass.sm");
    my @gcc = ('g++', '--std=c++98', '-Wall', '-Wextra', '-Wno-unused-parameter', '-DTRACE=printf');
    my $out = Util::run(@gcc, "-I runtime/c++ -I . -o t/c++/${test} t/c++/${test}.cpp t/c++/Sm/TestClass.cpp t/c++/Sm/TestClassContext.cpp");
    diag($out) if $out;
    my $trace = $options =~ /-g0/ && ${Util::smc} !~ /\.jar/ ? 'g0' : '';
    $out = Util::run(catfile('t', 'c++', ${test}), $trace);
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

unless (`g++ --version 2>&1` =~ /^g++/) {
    plan skip_all => 'no g++';
}
plan tests => scalar(@Util::tests) * scalar(@opt);

for my $test (@Util::tests) {
    Util::test_smc_with_options('c++/Sm', \&test_smc_cpp, $test, \@opt);
}

