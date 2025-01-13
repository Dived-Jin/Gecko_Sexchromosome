#!/usr/bin/perl -w
use strict;

die "perl $0 <seg_tab.add> <col> <gap_size>" unless @ARGV == 3;

open(IN, $ARGV[0]) or die $!;
my ($chr, $block, $scaf, $beg, $end, $bg1, $ed1);
while(<IN>){
	chomp;
	my @tmp = split /\t/;
	my $len = $tmp[$ARGV[1]+2] - $tmp[$ARGV[1]+1] + 1;
	my ($bg, $ed);
	if(defined $chr){
		if($tmp[0] eq $chr){
			my $strand = $tmp[$ARGV[1]+1] > $beg ? '+' : '-';
			#my $gap = $strand eq '+' ? $tmp[$ARGV[1]+1]-$end+1 : $beg-$tmp[$ARGV[1]+2]-1;
			$bg = $ed1 + $ARGV[2];
			$bg1 = $bg;
			$ed = $bg+$len-1;
			$ed1 = $ed;
		}
		else{
			$bg = 1;
			$ed = $bg+$len-1;
			$ed1 = $ed;
		}
	}
	else{
		$chr = $tmp[0];
		$block = $tmp[1];
		$bg = 1;
		$bg1 = 1;
		$ed = $bg+$len-1;
		$ed1 = $ed;
	}
	$chr = $tmp[0];
	$block = $tmp[1];
	$scaf = $tmp[$ARGV[1]];
	$beg = $tmp[$ARGV[1]+1];
	$end = $tmp[$ARGV[1]+2];
	print "$chr\t$block\t$tmp[$ARGV[1]-1]\t$bg\t$ed\n";
}
close IN;

