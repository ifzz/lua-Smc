
package Util;

use strict;
use warnings;
use Fatal qw(open close);

our $lua = $ENV{LUA} || 'lua';
#our $lua = 'luajit';
our $smc = $ENV{SMC} || $lua . ' ./bin/smc';
#our $smc = 'java -jar Smc.jar';
#our $smc = 'src_c/smc';
our $test_graph = !$ENV{TRAVIS} && 1;
our $test_table = !$ENV{TRAVIS} && 0;
our @tests = qw(
    Simple
    EntryExit
    Guard
    Default
    PushJump
    TransUndef
);
our $config;

sub slurp {
    my ($filename) = @_;
    local $/;
    undef $/;
    open my $fh, '<', $filename;
    read $fh, my $text, 4096;
    close $fh;
    return $text;
}

sub spew {
    my ($filename, $text) = @_;
    open my $fh, '>', $filename;
    print {$fh} $text;
    close $fh;
}

sub run {
    my $cmd = join ' ', @_;
#    print $cmd, "\n";
    return qx{$cmd 2>&1};
}

sub do_fsm {
    my ($dest, $fsm) = @_;
    my $sm = slurp("t/templates/${fsm}.sm");
    $sm =~ s/@(\w+)@/$config->{$1}/g;
    spew("t/${dest}/TestClass.sm", $sm);
}

sub test_smc_graph {
    my ($dest, $test, $level) = @_;
    unlink("t/${dest}/TestClass.sm");
    unlink("t/${dest}/TestClassContext.dot");
    unlink("t/${dest}/TestClassContext${level}.png");
    do_fsm($dest, $test);
    system("${smc} -graph -glevel ${level} t/${dest}/TestClass.sm");
    system("dot -T png -o t/${dest}/TestClassContext${level}.png t/${dest}/TestClassContext.dot");
}

sub test_smc_table {
    my ($dest, $test) = @_;
    unlink("t/${dest}/TestClass.sm");
    unlink("t/${dest}/TestClassContext.html");
    do_fsm($dest, $test);
    system("${smc} -table t/${dest}/TestClass.sm");
    unless ($smc =~ /\.jar/) {
        system("xmllint -noout -valid t/${dest}/TestClassContext.html");
    }
}

sub test_smc_with_options {
    my ($dest, $func, $test, $options) = @_;
    for my $option (@{$options}) {
        &$func($test, $option);
    }
    if ($test_graph) {
        for my $level (0..2) {
            test_smc_graph($dest, $test, $level);
        }
    }
    if ($test_table) {
        test_smc_table($dest, $test);
    }
}

1;
