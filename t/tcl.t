#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin";

use Test::More;
use Test::LongString;
use Util;

$Util::smc = 'java -jar Smc.jar';
#$Util::test_graph = 0;
#$Util::test_table = 0;
@Util::tests = qw(
    Simple
    EntryExit
    TransUndef
);
#@Util::tests = ( 'Simple' );

my @opt = (
    '',
    '-g0',
    '-g1',
    '-noc',
    '-noc -g0',
    '-noc -g1',
    '-serial',
);

$Util::config = {
    code        => '# comment',
    import1     => 'statemap',
    import2     => 'statemap',
    include1    => 'a',
    include2    => 'b',
    is_ok       => '[$ctxt isOk]',
    is_nok      => '[$ctxt isNok]',
    false       => 'false',
    n           => 'n',
    param       => 'n: value',
    prop1       => '',
    prop2       => '',
};

my %re = (
    TransUndef  => 'Transition',
);

sub test_smc_tcl {
    my ($test, $options) = @_;
    unlink("t/tcl/Sm/TestClass.sm");
    unlink("t/tcl/Sm/TestClassContext.tcl");
    Util::do_fsm('tcl/Sm', $test);
    system("${Util::smc} -tcl ${options} t/tcl/Sm/TestClass.sm");
    my $trace = $options =~ /---g0/ ? 'g0' : '';
    my $out = Util::run('tclsh', "t/tcl/${test}.tcl", $trace);
    my $expected = $trace
                 ? Util::slurp("t/templates/${test}.g0.out")
                 : Util::slurp("t/templates/${test}.out");
    if ($expected =~ /^like/) {
        like_string($out, qr{$re{$test}}, "$test $options");
    }
    else {
        is_string($out, $expected, "$test $options");
    }
}

unless (`which tclsh` =~ /^\//) {
    plan skip_all => 'no tcl';
}
plan tests => scalar(@Util::tests) * scalar(@opt);

for my $test (@Util::tests) {
    Util::test_smc_with_options('tcl/Sm', \&test_smc_tcl, $test, \@opt);
}

