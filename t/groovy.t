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
    '-reflect',
    '-serial',
    '-sync',
);

$Util::config = {
    code        => '// comment',
    import1     => 'java.io.File',
    import2     => 'groovy.lang.Script',
    include1    => 'a',
    include2    => 'b',
    is_ok       => 'ctxt.isOk()',
    is_nok      => 'ctxt.isNok()',
    false       => 'false',
    n           => 'n',
    param       => 'n: int',
    prop1       => 'myProp = true;',
    prop2       => 'myProp = false;',
};

my %re = (
    TransUndef  => 'statemap\.TransitionUndefinedException: State: (Sm::)?Map_1(::|\.)State_1, Transition: Evt_1',
);

sub test_smc_groovy {
    my ($test, $options) = @_;
    unlink("t/groovy/Sm/TestClass.sm");
    unlink("t/groovy/Sm/TestClassContext.groovy");
    Util::do_fsm('groovy/Sm', $test);
    system("${Util::smc} -groovy ${options} t/groovy/Sm/TestClass.sm");
    my $trace = $options =~ /-g0/ && ${Util::smc} !~ /\.jar/ ? 'g0' : '';
    my $out = Util::run('cd t/groovy && groovy -classpath ../../runtime/groovy/statemap.jar', $test, $trace);
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

unless (`groovy -v` =~ /^Groovy/) {
    plan skip_all => 'no groovy';
}
plan tests => scalar(@Util::tests) * scalar(@opt);

for my $test (@Util::tests) {
    Util::test_smc_with_options('groovy/Sm', \&test_smc_groovy, $test, \@opt);
}

