#!usr/bin/perl -w
use strict;

die "perl $0 <block_list.txt>" unless @ARGV == 1;

my %hash;
open(IN, $ARGV[0]) or die $!;
while(<IN>){
	chomp;
	my ($chr, $bg, $ed) = (split /\t/)[0,1,2];
	$hash{$chr}{$bg} = $ed;
}
close IN;

my $idx = 1;
foreach my $chr (sort keys %hash){
	my @sort = sort {$a<=>$b} keys %{$hash{$chr}};
	my @out;
	for(my $i=0;$i<@sort;$i++){
		push @out, $idx;
		print "$chr\t$sort[$i]\t$hash{$chr}{$sort[$i]}\t$idx\t$i\n";
		$idx++;
	}
	my $out = join " ", @out;
	print STDERR "#$chr\n$out \$\n";
}

