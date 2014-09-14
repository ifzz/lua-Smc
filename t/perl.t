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
    code        => '# comment',
    import1     => 'File::Find',
    import2     => 'IO::File',
    include1    => 'a',
    include2    => 'b',
    is_ok       => '$ctxt->isOk()',
    is_nok      => '$ctxt->isNok()',
    false       => '0',
    n           => '$n',
    param       => '$n',
    prop1       => 'myProp = 1;',
    prop2       => 'myProp = 0;',
};

my %re = (
    TransUndef  => 'TransitionUndefinedException\nState: (Sm::)?Map_1(::|\.)State_1\nTransition: Evt_1',
);

sub test_smc_perl {
    my ($test, $options) = @_;
    unlink("t/perl/Sm/TestClass.sm");
    unlink("t/perl/Sm/TestClassContext.pm");
    Util::do_fsm('perl/Sm', $test);
    system("${Util::smc} -perl ${options} t/perl/Sm/TestClass.sm");
    my $trace = $options =~ /-g0/ && ${Util::smc} !~ /\.jar/ ? 'g0' : '';
    my $out = Util::run('perl', "-I t/perl -I runtime/perl t/perl/${test}.pl", $trace );
    my $expected = $trace
                 ? Util::slurp("t/templates/${test}.g0.out")
                 : Util::slurp("t/templates/${test}.out");
    if ($expected =~ /^like/) {
        like($out, qr{$re{$test}}, "$test $options");
    }
    else {
        $out =~ s/\$n/n/gm;
        is($out, $expected, "$test $options");
    }
}

unless (`perl -version` =~ /^\nThis is perl/) {
    plan skip_all => 'no perl';
}
plan tests => scalar(@Util::tests) * scalar(@opt);
diag($Util::smc);

for my $test (@Util::tests) {
    Util::test_smc_with_options('perl/Sm', \&test_smc_perl, $test, \@opt);
}

