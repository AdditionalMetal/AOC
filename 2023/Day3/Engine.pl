#!/bin/perl
# This was a terrible approach...
use strict;
use diagnostics;

*ARGV = *DATA unless @ARGV;

my %map = ();
my %remap = ();
my %refmap = ();
my ($r, $c) = (0,0);

while(<>){
  chomp;
  $r = $.;
  $c = length $_;

  my @f = split //, $_;
  foreach my $i (0..$#f){
    $map{$. . ":" . (1+$i)} = $f[$i];
  }
}

my @symbols = ();
foreach my $i (1..$r){ # row
  foreach my $j (1..$c){ # column
    my $v = $map{"${i}:${j}"};

    if ($v =~ m/\d/i){ # Number?
      # replace individual digits with full number...
      #   you only need to move forward in columns
      #   and track if you already finished.
      my $num = '';
      my @store = ();

      foreach my $J ($j..$c){
	last if ($remap{"${i}:${J}"});

	my $digit = $map{"${i}:${J}"};
	if ($digit =~ m/\d/){
	  $num =  $num . $digit;
	  push @store, "${i}:${J}";
	} else {
	  $remap{"${i}:${J}"} = $map{"${i}:${J}"};

	  map { $remap{$_} = $num; } @store;
	  map { $refmap{$_} = \@store } @store;
	  last;
	}
	map { $remap{$_} = $num; } @store;
      }
    } else { # Not a number...
      $remap{"${i}:${j}"} = $map{"${i}:${j}"};

      if ($v =~ m/[^\.\d]/){ # Symbol...
	push @symbols, "${i}:${j}";
      }
    }
  }
}

# Print remap...
foreach my $i (1..$r){ # row
  print "$i: ";
  foreach my $j (1..$c){ # column
    print $remap{"${i}:${j}"} . " ";
  }
  print "\n";
}
print "\n";

print "Symbol Locations: " . join(" ", @symbols) . "\n";
# print "Equivalences...\n";
# map {print "$_ -> @{$refmap{$_}} \n"; } sort keys %refmap;

# Determine which numbers are engine parts...
#  Need to also protect from over-counting... And this becomes crap...
foreach my $symbol (@symbols){
  my ($R, $C) = split /:/, $symbol;

  #print "**************************************************\n";
  #print "$symbol => $R -> $C => " . $remap{$symbol} . "\n";

  $remap{$symbol} = [$remap{$symbol}]; # Turn into an array???

  my @LOCS = ( ($R + 0) . ":" . ($C - 1) , # Leading in Same Row
	       ($R + 0) . ":" . ($C + 1) , # Trailing in Same Row
	       ($R - 1) . ":" . ($C + 0) , # Upper in same column
	       ($R + 1) . ":" . ($C + 0) , # Lower in same column
	       ($R - 1) . ":" . ($C - 1) , # Leading Upper Diagnal
	       ($R + 1) . ":" . ($C - 1) , # Leading Lower Diagnal
	       ($R - 1) . ":" . ($C + 1) , # Trailing Upper Diagnal
	       ($R + 1) . ":" . ($C + 1) , # Trailing Lower Diagnal
	     );

  foreach my $loc (@LOCS){
    if ($remap{$loc} and $remap{$loc} =~ m/\d/){
      push @{$remap{$symbol}}, $remap{$loc};
      map { $remap{$_} = 0 } @{$refmap{$loc}};
    }
  }

  print "$symbol -> ";
  print join(", ", @{$remap{$symbol}}) if ($remap{$symbol});
  print "\n";
}

my ($tot, $gear) = (0,0);
foreach my $symbol (@symbols){
  my $op = shift @{$remap{$symbol}};
  map {$tot += $_ } @{$remap{$symbol}};

  if ($op eq "*" and (2 == @{$remap{$symbol}})){
    $gear += $remap{$symbol}->[0] * $remap{$symbol}->[1];
  }
}

print "\n\n";
print "Total: $tot\n";
print "Gear: $gear\n";

__DATA__
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
