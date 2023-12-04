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
  print "$i : ";
  foreach my $j (1..$c){ # column
    my $v = $map{"${i}:${j}"};

    # replace individual digits with full number...
    #   you only need to move forward in columns
    #   and track if you already finished.
    if ($v =~ m/\d/i){
      my $num = '';
      my @store = ();

      foreach my $J ($j..$c){ # going towards eol...
	print "Already stored... $i:$J \n" and last if ($remap{"${i}:${J}"}); # already stored...

	my $digit = $map{"${i}:${J}"};
	if ($digit =~ m/\d/){
	  $num =  $num . $digit;
	  push @store, "${i}:${J}";
	  print "Preparing to store ${i}:${J} index...(now at @{store})\n";
	} else {
	  $remap{"${i}:${J}"} = $map{"${i}:${J}"};

	  # store in remap...
	  print "********checking store: @store \n";
	  map {"print using $_ index\n";
	       $remap{$_} = $num;
	     } @store;
	  $num = '';
	  @store = ();
	  last;
	}
      }

      # # MEA CULPA - don't need to go in both directions,
      # #             you just need to keep track of what changed
      # foreach my $J (reverse (1..$j)){ # going towards start of line (sol?)...
      # 	my $digit = $map{"${i}:${J}"};
      # 	if ($digit =~ m/\d/){
      # 	  $num =  $digit . $num;
      # 	} else {
      # 	  last;
      # 	}
      # }

      # $remap{"${i}:${j}"} = 0 + $num;
      # print " $num"
    } else {
      $remap{"${i}:${j}"} = $map{"${i}:${j}"};
      print " $v";
    }
  }
  # Row...
  print "\n";
}

print "\n";
foreach my $i (1..$r){ # row
  print "$i : ";
  foreach my $j (1..$c){ # column
    print $remap{"${i}:${j}"} . " " ;
  }
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
