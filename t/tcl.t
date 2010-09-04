#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin";

use Test::More;
use Util;

$Util::smc = 'java -jar Smc.jar';
#$Util::test_graph = 0;
$Util::test_table = 0;
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
    unlink("t/tcl/TestClass.sm");
    unlink("t/tcl/TestClassContext.tcl");
    Util::do_fsm('tcl', $test);
    system("${Util::smc} -tcl ${options} t/tcl/TestClass.sm");
    my $out = Util::run('tclsh', "t/tcl/${test}.tcl");
    my $expected = Util::slurp("t/templates/${test}.out");
    if ($expected =~ /^like/) {
        like($out, qr{$re{$test}}, "$test $options");
    }
    else {
        is($out, $expected, "$test $options");
    }
}

unless (`which tclsh` =~ /^\//) {
    plan skip_all => 'no tcl';
}
plan tests => scalar(@Util::tests) * scalar(@opt);

for my $test (@Util::tests) {
    Util::test_smc_with_options('tcl', \&test_smc_tcl, $test, \@opt);
}

