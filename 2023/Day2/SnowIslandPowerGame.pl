#!/bin/perl
use strict;
use diagnostics;

my %games = ();

*ARGV = *DATA unless @ARGV;

my $sum = 0;
while(<>){
  #print "\n$_";
  chomp;

  my @sets = split /[:;]/, $_;
  my $game = shift @sets;

  #print "$game\n";

  foreach my $set (@sets){
    my @colorCnt = split /,/, $set;
    map { $_ =~ s/^\s*//;
	  my ($cnt, $color) = split /\s/, $_ ;

	  $games{$game}->{$color} ||= 0;
	  $games{$game}->{$color} = $cnt
	      if  ($cnt > $games{$game}->{$color});

	  #print "\t\t$color -> $cnt : $games{$game}->{$color}\n";
	} @colorCnt;
  }
  print "$game: ";
  my $power = 1;
  map { print "$_ : $games{$game}->{$_} ";
	$power *= $games{$game}->{$_};
      } reverse sort keys %{$games{$game}};
  print " Power: $power";
  print "\n";
  $sum += $power;
}
print "Total: $sum\n";

# Directly from problem description...
__DATA__
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
