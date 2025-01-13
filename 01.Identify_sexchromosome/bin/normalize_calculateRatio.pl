#!/usr/bin/perl -w
use strict;

die "perl $0 <bedcov.50k.cov> <male_peak> <female_peak> <XY|ZW>" unless @ARGV == 4;

open(IN, $ARGV[0]) or die $!;
while(<IN>){
	chomp;
	my ($scafID, $bg, $ed, $mmdep, $mdep, $mcov, $fmdep, $fdep, $fcov) = (split /\t/)[0,1,2,3,4,5,6,7,8];
	$mmdep = 0 if($mmdep eq '.');
	$mdep = 0 if($mdep eq '.');
	$fmdep = 0 if($fmdep eq '.');
	$fdep = 0 if($fdep eq '.');
	my $nmdep = sprintf "%.4f", $mdep*$mcov/($ed-$bg)/$ARGV[1];
	my $nfdep = sprintf "%.4f", $fdep*$fcov/($ed-$bg)/$ARGV[2];
	my $mcoverage = sprintf "%.4f", $mcov/($ed-$bg);
	my $fcoverage = sprintf "%.4f", $fcov/($ed-$bg);
	$mdep = sprintf "%.4f", $mdep;
	$fdep = sprintf "%.4f", $fdep;
	my $ratio;
	if($ARGV[3] eq 'ZW'){
		if($nfdep == 0){
			$ratio = 'NA';
		}
		else{
			$ratio = sprintf "%.4f", $nmdep/$nfdep;
		}
	}
	elsif($ARGV[3] eq 'XY'){
		if($nmdep == 0){
			$ratio = 'NA';
		}
		else{
			$ratio = sprintf "%.4f", $nfdep/$nmdep;
		}
	}
	else{
		die "the fourth argument should be either XY or ZW!\n";
	}
	my $out = join("\t", $scafID, $bg, $ed, $mmdep, $mdep, $mcov, $fmdep, $fdep, $fcov, $nmdep, $nfdep, $ratio, $mcoverage, $fcoverage);
	print "$out\n";
}
close IN;

