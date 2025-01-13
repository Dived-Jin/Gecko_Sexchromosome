#!/usr/bin/perl -w
use strict;

die "perl $0 <_conserved.segments.tmp2> <species_list>" unless @ARGV == 2;

my @spe = split /-/, $ARGV[1];
my %hash;
foreach (@spe){
	$hash{$_} = 1
}

open(IN, $ARGV[0]) or die $!;
$/ = "\n\n";
my $idx = 1;
while(<IN>){
	chomp;
	my @tmp = split /\n/;
	my $flag = 0;
	my %count;
	foreach (@tmp){
		my $spe = (split /\./, $_)[0];
		$count{$spe}++;

	}
	foreach my $spe (keys %hash){
		if(!exists $count{$spe} || $count{$spe} != 1){
			$flag = 1;
			last;
		}
	}
	#my $out = join "\n", @tmp;
	#print "$out\n\n";
	if($flag == 0){
		$_ =~ s/^>(\d+)\n/>$idx\n/;
		print "$_\n\n";
		$idx++;
	}
}
close IN;

