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
    TransUndef  => '\(Statemap::TransitionUndefinedException\)\nState: (Sm::)?Map_1(::|\.)State_1\nTransition: Evt_1',
);

sub test_smc_ruby {
    my ($test, $options) = @_;
    unlink("t/ruby/Sm/TestClass.sm");
    unlink("t/ruby/Sm/TestClassContext.rb");
    Util::do_fsm('ruby/Sm', $test);
    system("${Util::smc} -ruby ${options} t/ruby/Sm/TestClass.sm");
    my $trace = $options =~ /-g0/ && ${Util::smc} !~ /\.jar/ ? 'g0' : '';
    my $out = Util::run('ruby', "-I t/ruby -I t/ruby/Sm -I runtime/ruby t/ruby/${test}.rb", $trace);
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

unless (`ruby -v` =~ /^ruby/) {
    plan skip_all => 'no ruby';
}
plan tests => scalar(@Util::tests) * scalar(@opt);

for my $test (@Util::tests) {
    Util::test_smc_with_options('ruby/Sm', \&test_smc_ruby, $test, \@opt);
}

