#!/bin/perl
use strict;
use diagnostics;

my $sum = 0;

while (<>){
    chomp;
    my $f = $1 if ($_ =~ m/^[^\d]*(\d)/);
    my $l = $1 if ($_ =~ m/(\d)[^\d]*$/);

    my $num = 0 + "${f}${l}";
    $sum += $num;
    print "$_ -> $num\n";
}

print "\nCalibration: $sum\n";
