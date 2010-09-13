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
    import1     => 'StateMachine/statemap.php',
    import2     => 'StateMachine/statemap.php',
    include1    => 'a',
    include2    => 'b',
    is_ok       => '$ctxt->isOk()',
    is_nok      => '$ctxt->isNok()',
    false       => '0',
    n           => '$n',
    param       => '$n',
    prop1       => '',
    prop2       => '',
};

my %re = (
    TransUndef  => "'TransitionUndefinedException' with message '\n\tState: Map_1(::|\.)State_1\n\tTransition: Evt_1'",
);

sub test_smc_php {
    my ($test, $options) = @_;
    unlink("t/php/TestClass.sm");
    unlink("t/php/TestClassContext.pphp");
    Util::do_fsm('php', $test);
    system("${Util::smc} -php ${options} t/php/TestClass.sm");
    my $trace = $options =~ /-g0/ && ${Util::smc} !~ /\.jar/ ? 'g0' : '';
    my $out = Util::run('php', "-q t/php/${test}.php", $trace);
    my $expected = $trace
                 ? Util::slurp("t/templates/${test}.g0.out")
                 : Util::slurp("t/templates/${test}.out");
    if ($expected =~ /^like/) {
        like_string($out, qr{$re{$test}}, "$test $options");
    }
    else {
        $out =~ s/\$n/n/gm;
        is_string($out, "\n\n" . $expected, "$test $options");
    }
}

unless (`php -v` =~ /^PHP/) {
    plan skip_all => 'no php';
}
plan tests => scalar(@Util::tests) * scalar(@opt);

for my $test (@Util::tests) {
    Util::test_smc_with_options('php', \&test_smc_php, $test, \@opt);
}

