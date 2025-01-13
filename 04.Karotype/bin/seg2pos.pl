#!/usr/bin/perl -w
use strict;

die "perl $0 <Conserved.Segments>" unless @ARGV == 1;

open(IN, $ARGV[0]) or die $!;
$/ = ">"; <IN>;
while(<IN>){
	chomp;
	my @tmp = split /\n/;
	my $id = $tmp[0];
	for(my $i=1;$i<@tmp;$i++){
		$tmp[$i] =~ /(\S+?)\.(\S+):(\d+)-(\d+) ([+-])/;
		my ($spe, $chr, $bg, $ed, $strand) = ($1, $2, $3, $4, $5);
		print "$spe#$id\t$spe\_$chr\t$strand\t$bg\t$ed\n";
	}
}
close IN;

