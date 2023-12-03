#!/bin/perl
use strict;
use diagnostics;

my %games = ( MAX_RED => 12,
	      MAX_GREEN => 13,
	      MAX_BLUE => 14,
            );

*ARGV = *DATA unless @ARGV;

my $sum;
while(<>){
  print "\n$_";
  chomp;

  my @sets = split /[:;]/, $_;
  my $game = shift @sets;

  $game =~ s/Game\s(\d+)/$1/;
  print "$game\n";

  my $possible = 1;
  foreach my $set (@sets){
    my @colorCnt = split /,/, $set;
    map { $_ =~ s/^\s*//;
	  my ($cnt, $color) = split /\s/, $_ ;
	  $games{$game}->{$color} += $cnt;
	  $possible = 0 if ($cnt > $games{"MAX_" . uc($color)});
	} @colorCnt;
  }
  $sum += $game if ($possible);
}
print "Total: $sum\n";

# Directly from problem description...
__DATA__
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
