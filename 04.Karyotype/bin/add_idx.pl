#!/usr/bin/perl -w
use strict;

die "perl $0 <sort.lst> <tab> <col>" unless @ARGV == 3;

my %hash;
open(IN, $ARGV[0]) or die $!;
while(<IN>){
	chomp;
	my ($chr, $bg, $ed, $idx) = (split /\t/)[0,1,2,3];
	$hash{"$chr\t$bg\t$ed"} = $idx;
}
close IN;

open(IN, $ARGV[1]) or die $!;
while(<IN>){
	chomp;
	my @tmp = split /\t/;
	my $id = join "\t", @tmp[$ARGV[2]..$ARGV[2]+2];
#print $id."\n";
    die $_ unless(exists $hash{$id});
    print "$_\t$hash{$id}\n";
}
close IN;

