#!/usr/bin/perl -w
use strict;

die "perl $0 <all.output.count.filt> <all.output.count.filt.norm>" unless @ARGV == 2;

my %hash;

open(IN, $ARGV[0]) or die $!;
while(<IN>){
	chomp;
	next if(/^ENSEMBL_GeneID/);
	my $id = (split /\t/)[0];
	$hash{$id} = 1;	
}
close IN;

open(IN, $ARGV[1]) or die $!;
my $h = <IN>;
print "$h";
my @h = split /\t/, $h;
my $n = @h;
while(<IN>){
	chomp;
	print "$_\n";
	my $id = (split /\t/)[0];
	delete $hash{$id} if(exists $hash{$id});
}
close IN;

foreach my $id (sort keys %hash){
	my $out = "\t0" x ($n-1);
	print "$id$out\n";
}
