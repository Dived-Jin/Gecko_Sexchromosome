#!/usr/bin/perl -w
use strict;

die "perl $0 <merge.50k.cov.ratio> <outdir> <ZW|XY>" unless @ARGV == 3;

mkdir $ARGV[1] unless(-e $ARGV[1]);
my $scaf1;

open(IN, $ARGV[0]) or die $!;
while(<IN>){
	chomp;
	next if(/^#/);
	my ($scaf, $bg, $ed, $md, $fd, $ratio) = (split /\t/)[0,1,2,9,10,11];
	my $mid = ($bg+$ed)/2;
	if(! defined $scaf1){
		open(OUT, "> $ARGV[1]/$scaf.txt.norm");
		print OUT "start\tend\tratio\tsex\ttype\n";
		$scaf1 = $scaf;
	}
	elsif($scaf1 ne $scaf){
		close OUT;
		open(OUT, "> $ARGV[1]/$scaf.txt.norm");
		print OUT "start\tend\tratio\tsex\ttype\n";
		$scaf1 = $scaf;
	}
	print OUT "$bg\t$ed\t$md\tmale\tdepth\n";
	print OUT "$bg\t$ed\t$fd\tfemale\tdepth\n";
	if($ARGV[2] eq 'ZW'){
		print OUT "$bg\t$ed\t$ratio\tm/f\tdepth\n"
	}
	elsif($ARGV[2] eq 'XY'){
		print OUT "$bg\t$ed\t$ratio\tf/m\tdepth\n";
	}
	else{
		die "the third argument should be either XY or ZW\n";
	}
}

close IN;

