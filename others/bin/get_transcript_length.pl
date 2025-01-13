#!/usr/bin/perl -w
use strict;

die "perl $0 <gtf>" unless @ARGV == 1;

my %hash;

open(IN, $ARGV[0]) or die $!;
while(<IN>){
	chomp;
	my @tmp = split /\t/;
	next unless($tmp[2] eq 'exon');
	$tmp[8] =~ /transcript_id "(\S+)"/;
	my $id = $1;
	$hash{$id} += $tmp[4]-$tmp[3]+1;
}
close IN;

foreach my $id (sort keys %hash){
	print "$id\t$hash{$id}\n";
}
