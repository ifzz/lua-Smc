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
);

$Util::config = {
    code        => '-- comment',
    import1     => 'table',
    import2     => 'io',
    include1    => 'a',
    include2    => 'b',
    is_ok       => 'ctxt:isOk()',
    is_nok      => 'ctxt:isNok()',
    false       => 'false',
    n           => 'n',
    param       => 'n',
    prop1       => 'myProp = true;',
    prop2       => 'myProp = false;',
};

my %re = (
    TransUndef  => 'Undefined Transition\nState: (Sm::)?Map_1(::|\.)State_1\nTransition: Evt_1',
);

sub test_smc_lua {
    my ($test, $options) = @_;
    unlink("t/lua/Sm/TestClass.sm");
    unlink("t/lua/Sm/TestClassContext.lua");
    Util::do_fsm('lua/Sm', $test);
    system("${Util::smc} -lua ${options} t/lua/Sm/TestClass.sm");
    my $trace = $options =~ /-g0/ && ${Util::smc} !~ /\.jar/ ? 'g0' : '';
    my $out = Util::run(${Util::lua}, "t/lua/${test}.lua", $trace);
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

my $version = qx{${Util::lua} -v 2>&1};
unless ($version =~ /^Lua/) {
    plan skip_all => 'no lua';
}
plan tests => scalar(@Util::tests) * scalar(@opt);
diag($Util::smc);
diag($version);

for my $test (@Util::tests) {
    Util::test_smc_with_options('lua/Sm', \&test_smc_lua, $test, \@opt);
}
