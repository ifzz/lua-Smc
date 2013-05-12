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
    '-reflect',
);

$Util::config = {
    code        => '/* comment */',
    import1     => 'structs/ArrayList',
    import2     => 'lang/String',
    include1    => '',
    include2    => '',
    is_ok       => 'ctxt isOk()',
    is_nok      => 'ctxt isNok()',
    false       => 'false',
    n           => 'n',
    param       => 'n: Int',
    prop1       => 'myProp = true;',
    prop2       => 'myProp = false;',
};

my %re = (
    TransUndef  => '\[TransitionUndefinedException in TransitionUndefinedException\]: State: Sm::Map_1::State_1, Transition: Evt_1',
);

sub test_smc_ooc {
    my ($test, $options) = @_;
    unlink("t/ooc/${test}");
    unlink("t/ooc/${test}.exe");
    unlink("t/ooc/Sm/TestClass.sm");
    unlink("t/ooc/Sm/TestClassContext.ooc");
    Util::do_fsm('ooc/Sm', $test);
    system("${Util::smc} -ooc ${options} t/ooc/Sm/TestClass.sm");
    my $out = Util::run("cd t/ooc && rock ${test}.ooc");
    diag($out) if $out && $out ne "[ OK ]\n";
    my $trace = $options =~ /-g0/ && ${Util::smc} !~ /\.jar/ ? 'g0' : '';
    $out = Util::run(catfile('t', 'ooc', ${test}), $trace);
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

if ($Util::smc =~ /jar/) {
    plan skip_all => 'no ooc target';
}

unless (`rock` =~ /^rock/) {
    plan skip_all => 'no rock';
}
plan tests => scalar(@Util::tests) * scalar(@opt);

unless (-e 't/ooc/statemap.ooc') {
    use File::Copy;
    copy('runtime/ooc/statemap.ooc', 't/ooc/statemap.ooc');
}

for my $test (@Util::tests) {
    Util::test_smc_with_options('ooc/Sm', \&test_smc_ooc, $test, \@opt);
}

