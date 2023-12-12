#!/bin/perl
# This was a terrible approach...
use strict;
use diagnostics;

*ARGV = *DATA unless @ARGV;

my %map = ();
my %remap = ();
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

# Determine which numbers are engine parts...
#  Need to also protect from over-counting... And this becomes crap...
foreach my $symbol (@symbols){
  my ($R, $C) = split /:/, $symbol;

  print "**************************************************\n";
  print "$symbol => $R -> $C => " . $remap{$symbol} . "\n";

  $remap{$symbol} = ();

  # Leading in Same Row
  unless ( $C == 1 ){
    push @{$remap{$symbol}}, $remap{"${R}:" . ($C - 1) } if ($remap{$R . ":" . ($C - 1) } =~ m/\d+/);
  }

  # Trailing in Same Row
  unless ( $C == $c){
    push @{$remap{$symbol}}, $remap{"${R}:" . ($C + 1) } if ($remap{$R . ":" . ($C + 1) } =~ m/\d+/);
  }

  # Upper in same column
  unless ($R == 1){
    push @{$remap{$symbol}}, $remap{($R-1) . ":${C}"}   if ($remap{$R-1 . ":" . $C} =~ m/\d+/);
  }

  # Lower in same column
  unless ($R == $r){
    push @{$remap{$symbol}}, $remap{($R+1) . ":${C}"}   if ($remap{$R+1 . ":" . $C} =~ m/\d+/);
  }

  # Leading Upper Diagnal
  unless ( $R == 1 and $C == 1){
    push @{$remap{$symbol}}, $remap{ ($R-1) .":". ($C-1) } if ( $remap{ ($R-1) .":". ($C-1) } =~ m/\d+/);
  }

  # Leading Lower Diagnal
  unless ( $R == $r and $C == 1){
    push @{$remap{$symbol}}, $remap{ ($R+1) .":". ($C-1) } if ( $remap{ ($R+1) .":". ($C-1) } =~ m/\d+/);
  }

  # Trailing Upper Diagnal
  unless ( $R == 1 and $C == $c){
    push @{$remap{$symbol}}, $remap{ ($R-1) .":". ($C+1) } if ( $remap{ ($R-1) .":". ($C+1) } =~ m/\d+/);
  }

  # Trailing Lower Diagnal
  unless ( $R == $r and $C == $c){
    push @{$remap{$symbol}}, $remap{ ($R+1) .":". ($C+1) } if ( $remap{ ($R+1) .":". ($C+1) } =~ m/\d+/);
  }

  print "$symbol -> ";
  print join(", ", @{$remap{$symbol}}) if ($remap{$symbol});
  print "\n";
}

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
