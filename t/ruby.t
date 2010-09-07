#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin";

use Test::More;
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
    code        => '# comment',
    import1     => 'statemap',
    import2     => 'statemap',
    include1    => 'a',
    include2    => 'b',
    is_ok       => 'ctxt.isOk()',
    is_nok      => 'ctxt.isNok()',
    false       => 'false',
    n           => 'n',
    param       => 'n',
    prop1       => 'myProp = true;',
    prop2       => 'myProp = false;',
};

my %re = (
    TransUndef  => '\(Statemap::TransitionUndefinedException\)\nState: Map_1(::|\.)State_1\nTransition: Evt_1',
);

sub test_smc_ruby {
    my ($test, $options) = @_;
    unlink("t/ruby/TestClass.sm");
    unlink("t/ruby/TestClassContext.rb");
    Util::do_fsm('ruby', $test);
    system("${Util::smc} -ruby ${options} t/ruby/TestClass.sm");
    my $out = Util::run('ruby', "-I t/ruby -I runtime/ruby t/ruby/${test}.rb");
    my $expected = Util::slurp("t/templates/${test}.out");
    if ($expected =~ /^like/) {
        like($out, qr{$re{$test}}, "$test $options");
    }
    else {
        is($out, $expected, "$test $options");
    }
}

unless (`ruby -v` =~ /^ruby/) {
    plan skip_all => 'no ruby';
}
plan tests => scalar(@Util::tests) * scalar(@opt);

for my $test (@Util::tests) {
    Util::test_smc_with_options('ruby', \&test_smc_ruby, $test, \@opt);
}

