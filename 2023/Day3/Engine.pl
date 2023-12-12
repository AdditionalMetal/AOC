#!/bin/perl
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

foreach my $i (1..$r){ # row
  foreach my $j (1..$c){ # column
    my $v = $map{"${i}:${j}"};

    if ($v =~ m/\d/i){
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
    } else {
      $remap{"${i}:${j}"} = $map{"${i}:${j}"};
    }
  }
}

# print remap...
foreach my $i (1..$r){ # row
  print "$i: ";
  foreach my $j (1..$c){ # column
    #print "${i}:${j} -> " . $remap{"${i}:${j}"} . "\n" ;
    #die "Arghh at $i and $j\n" unless $remap{"${i}:${j}"};
    print $remap{"${i}:${j}"} . " ";
  }
  print "\n";
}
print "\n";

# Now run through the remap array an look for "symbols"...
my %moRemap = ();
my @sym = ();
foreach my $i (1..$r){ # row
  print "$i : ";
  foreach my $j (1..$c){ # column
    if ($remap{"${i}:${j}"} =~ m/[^\.\d]/){ # symbol found...
      # Check all spaces around...
      push @sym, "${i}:${j}";
      print "#";
    } else {
      print "${i}:${j}\n";
      ($remap{"${i}:${j}"} =~ m/\d+/) ? print "N" : print ".";
    }
#    print $remap{"${i}:${j}"} . " " ;
  }
  print "\n";
}

print "Symbol Locations: " . join(" ", @sym) . "\n";

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
