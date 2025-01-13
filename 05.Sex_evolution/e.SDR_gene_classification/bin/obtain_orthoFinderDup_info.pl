#!/usr/bin/perl -w
use strict;

die "perl $0 <Gene_Duplication_Events/Duplications.tsv> <aristelliger_praesignis.ZW.gff.bed.sort.add_idx.nonPARZ_int> <prefix> <cutoff>" unless @ARGV == 4;

my $prefix = $ARGV[2];
my $cutoff = $ARGV[3];
my %hash;

open(IN, $ARGV[0]) or die $!;
while(<IN>){
	chomp;
	next if(/^Orthogroup\t/);
	my ($node, $support, $info1, $info2) = (split /\t/)[1,3,5,6];
	next unless($support > $cutoff);
	my @info1 = split /, /, $info1;
	my @info2 = split /, /, $info2;
	foreach my $gid (@info1){
		$gid =~ s/^$prefix\_//;
		$hash{$gid} = $node; #unless(exists $hash{$gid});
	}
	foreach my $gid (@info2){
		$gid =~ s/^$prefix\_//;
		$hash{$gid} = $node; #unless(exists $hash{$gid});
	}
}
close IN;

open(IN, $ARGV[1]) or die $!;
while(<IN>){
	chomp;
	my $gid = (split /\t/)[6];
	if(exists $hash{$gid}){
		print "$_\tdup_at_$hash{$gid}\n";
	}
	else{
		print "$_\tnodup\n";
	}
}
close IN;

