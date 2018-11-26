#!/usr/bin/env perl

my $numKmers = shift ;  #  The number of kmers in the input dump file.
my $totKmers = shift ;  #  The total number of kmers in the reads.

printf "%s\t%d\n", 0, $numKmers * 2;

while (<STDIN>) {
  chomp;

  my @v = split '\s+', $_;

  printf "%s\t%.10f\t%d\t%d\n", $v[0], $v[1] / $totKmers, $v[1], $totKmers;

  $v[0] =  reverse $v[0];
  $v[0] =~ tr/ACGT/TGCA/;

  printf "%s\t%.10f\t%d\t%d\n", $v[0], $v[1] / $totKmers, $v[1], $totKmers;
}

exit(0);
