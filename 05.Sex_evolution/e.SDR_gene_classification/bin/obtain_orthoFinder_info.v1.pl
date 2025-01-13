#!/usr/bin/perl -w
use strict;

die "perl $0 <Phylogenetic_Hierarchical_Orthogroups/N0.tsv> <aristelliger_praesignis.ZW.gff.bed.sort.add_idx.nonPARZ_int>" unless @ARGV == 2;

my (%hash, %HOG, %OG);

open(IN, $ARGV[0]) or die $!;
my $header = <IN>;
chomp($header);
my @header = split /\t/, $header;
while(<IN>){
	next if(/^HOG\t/);
	chomp;
	my @tmp = split /\t/;
	my ($HOG, $OG) = @tmp[0,1];
	for(my $i=3;$i<@tmp;$i++){
		my @temp = split /, /, $tmp[$i];
		foreach my $gid (@temp){
			for(my $i=3;$i<@tmp;$i++){
				if($tmp[$i] ne ''){
					$hash{$gid}{$header[$i]} = 1;
				}
			}
			$OG{$gid} = $OG;
			$HOG{$gid} = $HOG;
		}
	}
}
close IN;

open(IN, $ARGV[1]) or die $!;
while(<IN>){
	chomp;
	my $gid = (split /\t/)[6];
	my ($spe, $num, $HOG, $OG);
	if(exists $hash{$gid}){
		my @tmp = sort keys %{$hash{$gid}};
		$OG = $OG{$gid};
		$HOG = $HOG{$gid};
		$num = @tmp;
		$spe = join(",", @tmp);
	}
	else{
		$HOG = 'NA';
		$OG = 'NA';
		$spe = 'NA';
		$num = 0;
	}
	print "$_\t$HOG\t$OG\t$num\t$spe\n";
}
close IN;

