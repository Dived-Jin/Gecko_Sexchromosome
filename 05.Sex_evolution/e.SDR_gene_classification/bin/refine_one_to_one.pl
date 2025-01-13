#!/usr/bin/perl -w
use strict;

die "perl $0 <19species.ort.filt> <ARIPRA.gff.bed.sort.add_idx.nonPARXZ_int.add.add.add>" unless @ARGV == 2;

my %hash;

open(IN, $ARGV[0]) or die $!;
while(<IN>){
	chomp;
	my @tmp = split /\t/;
	for(my $i=0;$i<@tmp;$i+=6){
		$hash{$tmp[$i]} = 1;
	}
}
close IN;

open(IN, $ARGV[1]) or die $!;
while(<IN>){
	chomp;
	my ($gid, $type) = (split /\t/)[6,14];
	if(exists $hash{$gid}){
		my $type1 = 'ancestral';
		$_ =~ s/\t$type$/\t$type1/;
	}
	print "$_\n";
}
close IN;

