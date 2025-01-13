#!/usr/bin/perl -w
use strict;

die "perl $0 <N0.tsv>" unless @ARGV == 1;

my %idx;

open(IN, $ARGV[0]) or die $!;
my $header = <IN>;
chomp($header);
my @header = split /\t/, $header;
my $header_out = "Desc\tFamily ID";
for(my $i=3;$i<@header;$i++){
	$header_out .= "\t$header[$i]";
	$idx{$header[$i]} = $i;
}
print "$header_out\n";
while(<IN>){
	chomp;
	my @tmp = split /\t/;
	my $out = "$tmp[0]\t$tmp[0]";
	my %count;
	for(my $i=3;$i<@tmp;$i++){
		next if($tmp[$i] eq '');
		my @temp = split /, /, $tmp[$i];
		my $n = @temp;
		my $spe = (split /_/, $temp[0])[0];
		$count{$idx{$spe}} = $n;
	}
	my ($species_num, $sum);
	for(my $i=3;$i<@header;$i++){
		$count{$i} = 0 unless(exists $count{$i});
		$out .= "\t$count{$i}";
		$sum += $count{$i};
		$species_num += 1 if($count{$i} > 0);
	}
	print "$out\t$species_num\t$sum\n";
}
close IN;

