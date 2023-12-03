#!/bin/perl
use strict;
use diagnostics;

my $sum = 0;

while (my $input = <>){
    chomp $input;

    # Convert to numbers before proceeding...
    # my @subs = qw( one two three four five six seven eight nine );
    #  just brute force...
    my $regex = 'one|two|three|four|five|six|seven|eight|nine';
    my $xeger = reverse $regex;

    $regex = '\d|' . ${regex};
    $xeger = '\d|' . ${xeger};
    
    my $f = " NOT FOUND! ";
    my $l = " NOT FOUND! ";
    $f = $1 if ($input =~ m/[^${regex}]*($regex)/);

    my %letters2num = ( one => 1, two => 2, three => 3,
		        four => 4, five => 5, six => 6,
		        seven => 7, eight => 8, nine => 9
	);
    $f = $letters2num{$f} if ($letters2num{$f});						
    
    my $tupni = reverse $input;
    $l = reverse $1 if ($tupni =~ m/[^${xeger}]*($xeger)/);
    $l = $letters2num{$l} if ($letters2num{$l});
    
    my $num = 0 + "${f}${l}";
    $sum += $num;
    print "$input -> $f $l -> $num\n";
}

print "\nCalibration: $sum\n";

