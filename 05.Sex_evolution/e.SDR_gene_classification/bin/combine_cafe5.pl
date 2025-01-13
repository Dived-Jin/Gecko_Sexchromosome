#!/usr/bin/perl -w
use strict;

die "perl $0 <Base_change.tab> <ARIPRA.gff.bed.sort.add_idx.nonPARXZ_int.add.add> <target_species> <outgroup> <ingroup_min_number>" unless @ARGV == 5;

my (%idx, %hash);

my $species = $ARGV[2];
my @outgroup = split /,/, $ARGV[3];
my $NUM = $ARGV[4];

open(IN, $ARGV[0]) or die $!;
my $header = <IN>;
chomp($header);
my @header = split /\t/, $header;
for(my $i=1;$i<@header;$i++){
	next if($header[$i] =~ /^\<\d+\>$/);
	my $spe = (split /\</, $header[$i])[0];
	$idx{$i} = $spe;
}
while(<IN>){
	chomp;
	my @tmp = split /\t/;
	my $HOG = $tmp[0];
	for(my $i=1;$i<@tmp;$i++){
		if(exists $idx{$i}){
			$hash{$tmp[0]}{$idx{$i}} = $tmp[$i];
		}
	}
}
close IN;

open(IN, $ARGV[1]) or die $!;
while(<IN>){
	chomp;
	my ($orthoFinder_DUP, $HOG, $info) = (split /\t/)[8,9,12];
	my $type; 
	if(exists $hash{$HOG}{$species}){
		if($orthoFinder_DUP =~ /dup_at_$species/){
			$type = 'gain';
		}
		elsif($hash{$HOG}{$species} eq '+0'){
			$type = 'ancestral';
		}
		elsif($hash{$HOG}{$species} =~ /^\+/){
			$type = 'gain';
		}
		else{
			$type = 'loss';
		}
		print "$_\t$hash{$HOG}{$species}\t$type\n";
	}
	else{
		my $flag = 0;
		foreach my $outgroup (@outgroup){
			if($info =~ /$outgroup/){
				$flag = 1;
				last;
			}
		}
		my @INFO = split /,/, $info;
		if($flag == 1){
			if($orthoFinder_DUP =~ /dup_at_$species/){
				$type = 'gain';
			}
			else{
				$type = 'ancestral';
			}
		}
		elsif($orthoFinder_DUP =~ /dup_at_$species/){
			$type = 'gain';
		}
		elsif(@INFO >= $NUM){
			$type = 'ancestral';
		}
		elsif($info eq 'NA' or $info eq $species){
			$type = 'gain';
		}
		else{
			$type = 'unknown';
		}
		print "$_\tNA\t$type\n";
	}
}
close IN;

