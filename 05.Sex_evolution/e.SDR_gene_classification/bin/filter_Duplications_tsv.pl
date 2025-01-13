#!/usr/bin/perl -w
use strict;
use Data::Dumper;

die "perl $0 <gene.lst/> <Duplications.tsv>" unless @ARGV == 2;

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
	my $out = join("\t", @tmp[0..4]);
	my $flag = 0;
	#my $N = @tmp;
	#print "#$N\n";
	for(my $i=5;$i<@tmp;$i++){
		my @temp = split /, /, $tmp[$i];
		#die Dumper(\@temp);
		my $gids = '';
		foreach my $gid (@temp){
			my $gid1 = $gid;
			$gid1 =~ s/^\w+?_//;
			if(exists $hash{$gid1}){
				$gids .= "$gid, ";
			}
		}
		$gids =~ s/, $//;
		if($gids eq ''){
			$flag = 1;
			last;
		}
		else{
			$out .= "\t$gids";
		}
	}
	print "$out\n" if($flag == 0);
}
close IN;

