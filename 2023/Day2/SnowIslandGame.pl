#!/bin/perl
use strict;
use diagnostics;

my %games = ( MAX_RED => 12,
	      MAX_GREEN => 13,
	      MAX_BLUE => 14,
            );

*ARGV = *DATA unless @ARGV;
while(<>){
  #print "\n$_";
  chomp;

  my @sets = split /[:;]/, $_;
  my $game = shift @sets;

  $game =~ s/Game\s(\d+)/$1/;
  #print "$game\n";

  foreach my $set (@sets){
    my @colorCnt = split /,/, $set;
    map { $_ =~ s/^\s*//;
	  my ($cnt, $color) = split /\s/, $_ ;
	  $games{$game}->{$color} += $cnt;
	} @colorCnt;
  }
}

my $sum;
foreach my $game (sort grep /\d+/, keys %games){
  print "Game: $game\n";

  my $possible = 1;
  map { #print "\t$_ - $games{$game}->{$_}\n";
	if ($games{$game}->{$_} <= $games{"MAX_" . uc($_)}){
	  print "\tPossible ";
	} else {
	  $possible = 0;
	  print "\tNot Possible ";
	}
	print "$_ $games{$game}->{$_} vs " . $games{"MAX_" . uc($_)} . "\n";
     } sort keys %{$games{$game}};

  $sum += $game if ($possible);
  # print "\t" . join ("\n\t", @sets) . "\n";
}
print "Total: $sum\n";

# Directly from problem description...
__DATA__
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
