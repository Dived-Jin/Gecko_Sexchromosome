#!/usr/bin/perl -w
use strict;

die "perl $0 <all.pairwise.tab.addDS_conversion.txt> <ARIPRA.gff.bed.sort.add_idx.nonPARYW_int.add.add.add.refine>" unless @ARGV == 2;

my %hash;

open(IN, $ARGV[0]) or die $!;
while(<IN>){
	chomp;
	my ($gid1, $gid2) = (split /\t/)[0,4];
	$hash{$gid1} = 1;
	$hash{$gid2} = 2;
}
close IN;

open(IN, $ARGV[1]) or die $!;
while(<IN>){
	chomp;
	my @tmp = split /\t/;
	$tmp[14] = 'ancestral' if(exists $hash{$tmp[6]});
	my $out = join("\t", @tmp);
	print "$out\n";
}
close IN;

