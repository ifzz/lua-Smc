
package Util;

use strict;
use warnings;
use Fatal qw(open close);

our $smc = 'lua ./bin/smc';
our $test_graph = 1;
our $test_table = 1;
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
    my ($lang, $fsm) = @_;
    my $sm = slurp("t/templates/${fsm}.sm");
    $sm =~ s/@(\w+)@/$config->{$1}/g;
    spew("t/${lang}/TestClass.sm", $sm);
}

sub test_smc_graph {
    my ($lang, $test, $level) = @_;
    unlink("t/${lang}/TestClass.sm");
    unlink("t/${lang}/TestClassContext.dot");
    unlink("t/${lang}/TestClassContext${level}.png");
    do_fsm($lang, $test);
    system("${smc} -graph -glevel ${level} t/${lang}/TestClass.sm");
    system("dot -T png -o t/${lang}/TestClassContext${level}.png t/${lang}/TestClassContext.dot");
}

sub test_smc_table {
    my ($lang, $test) = @_;
    unlink("t/${lang}/TestClass.sm");
    unlink("t/${lang}/TestClassContext.html");
    do_fsm($lang, $test);
    system("${smc} -table t/${lang}/TestClass.sm");
    unless ($smc =~ /\.jar/) {
        system("xmllint -noout -valid t/${lang}/TestClassContext.html");
    }
}

sub test_smc_with_options {
    my ($lang, $func, $test, $options) = @_;
    for my $option (@{$options}) {
        &$func($test, $option);
    }
    if ($test_graph) {
        for my $level (0..2) {
            test_smc_graph($lang, $test, $level);
        }
    }
    if ($test_table) {
        test_smc_table($lang, $test);
    }
}

1;
