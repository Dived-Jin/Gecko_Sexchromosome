#!/usr/bin/perl -w
use strict;

die "perl $0 <conv>" unless @ARGV == 1;

my %hash;
open(IN, $ARGV[0]) or die $!;
while(<IN>){
	chomp;
	my ($car, $end) = (split /\t/)[0,4];
	$hash{$car} = $end if(!exists $hash{$car} || $hash{$car} < $end);
}
close IN;

foreach my $car (sort {$a<=>$b} keys %hash){
	print "$car\t$hash{$car}\n";
}

