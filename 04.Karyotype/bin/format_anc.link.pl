#!/usr/bin/perl -w
use strict;
use Data::Dumper;

die "perl $0 <Mammalia_PQTREE_BAB.seg_tab.add.add.add.link.add.add.spe.cut> <anc_col>" unless @ARGV == 3;

my %hash;
open(IN, $ARGV[0]) or die $!;
while(<IN>){
	chomp;
	my @tmp = split /\t/;
	my ($anc, $idx) = (split /\t/)[$ARGV[1]-1, 6];
	push @{$hash{$anc}}, $idx;
}
close IN;

open(my $outfile, '>', $ARGV[2]);
foreach my $anc (sort keys %hash){
	my $out = join " ", @{$hash{$anc}};
	print $outfile "#$anc\n$out \$\n";
	#my $n = @{$hash{$anc}};
	#print "$anc\t$n\n";
}
close $outfile;
