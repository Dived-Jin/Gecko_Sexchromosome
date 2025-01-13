#!/usr/bin/perl -w
use strict;

die "perl $0 <kallisto.out.tsv>" unless @ARGV == 1;

open(IN, $ARGV[0]) or die $!;
while(<IN>){
	chomp;
	next if(/target_id\t/);
	my ($id, $count) = (split /\t/)[0,3];
	$count = int($count);
	print "$id\t$count\n";
}
close IN;

