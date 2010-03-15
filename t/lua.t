#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin";

use Test::More;
use Util;

#$Util::smc = 'java -jar Smc.jar';
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

sub test_smc_lua {
    my ($test, $options) = @_;
    unlink("t/lua/TestClass.sm");
    unlink("t/lua/TestClassContext.lua");
    Util::do_fsm('lua', $test);
    system("${Util::smc} -lua ${options} t/lua/TestClass.sm");
    my $out = Util::run('lua', "t/lua/${test}.lua");
    my $expected = Util::slurp("t/templates/${test}.out");
    is($out, $expected, "$test $options");
}

unless (`lua -v 2>&1` =~ /^Lua/) {
    plan skip_all => 'no lua';
}
plan tests => scalar(@Util::tests) * scalar(@opt);

for my $test (@Util::tests) {
    Util::test_smc_with_options('lua', \&test_smc_lua, $test, \@opt);
}
