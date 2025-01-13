#!/usr/bin/perl -w
use strict;
use Data::Dumper;

die "perl $0 <gene.lst/> <N0.tsv>" unless @ARGV == 2;

my %hash;

my @inFiles = `find $ARGV[0] -name '*.gene.tab'`;
foreach my $inFile (@inFiles){
	open(IN, $inFile) or die $!;
	while(<IN>){
		chomp;
		my $gid = (split /\t/)[6];
		$hash{$gid} = 1;
	}
	close IN;
}

open(IN, $ARGV[1]) or die $!;
my $header = <IN>;
chomp($header);
print "$header\n";
my @header = split /\t/, $header;
while(<IN>){
	chomp;
	my @tmp = split /\t{1}/;
	my $out = join("\t", @tmp[0..2]);
	my %store;
	#my $N = @tmp;
	#print "#$N\n";
	for(my $i=3;$i<@tmp;$i++){
		if($tmp[$i] ne ''){
			my @temp = split /, /, $tmp[$i];
			#die Dumper(\@temp);
			my $gids = '';
			foreach my $gid (@temp){
				if(exists $hash{$gid}){
					my $spe = (split /_/, $gid)[0];
					$store{$spe} .= "$gid, ";
				}
			}
		}
	}
	my $N = keys %store;
	if($N > 0){
		for(my $i=3;$i<@header;$i++){
			if(exists $store{$header[$i]}){
				$store{$header[$i]} =~ s/, $//;
				$out .= "\t$store{$header[$i]}";
			}
			else{
				$out .= "\t";
			}
		}
		print "$out\n";
	}
	#print "$out\n" if($prefix ne $out);
}
close IN;

