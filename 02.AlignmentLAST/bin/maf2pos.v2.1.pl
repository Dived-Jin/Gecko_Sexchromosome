#!/usr/bin/perl -w
use strict;
use FileHandle;

die "perl $0 <maf> <outdir> <species lst>\n e.g. perl $0 maf outdir Hsap-Mmus-Mdom-Tacu-Oana" unless @ARGV == 3;

my %fh;
my @spe = split /-/, $ARGV[2];
mkdir $ARGV[1] unless(-e $ARGV[1]);
foreach my $spe (@spe){
	$fh{$spe} = FileHandle->new("> $ARGV[1]/$spe.maf.pos");
}

if($ARGV[0] =~ /\.gz$/){
	open(IN, "zcat $ARGV[0]|") or die $!;
}
else{
	open(IN, $ARGV[0]) or die $!;
}
$/ = "\n\n";
my $idx = 1;
while(<IN>){
	chomp;
	my @tmp = split /\n/;
	my $flag = 0;
	for(my $i=1;$i<@tmp;$i++){
		next if($tmp[$i] =~ /^#/ or $tmp[$i] =~ /^a score=/);
		next if($tmp[$i] =~ /^i /);
		my ($info, $bg, $len, $strand, $scaf_len) = (split /\s+/, $tmp[$i])[1,2,3,4,5];
		$bg++;	#maf is zero-based
		my $ed;
		if($strand eq '+'){
			$ed = $bg+$len-1;
		}
		else{
			$ed = $scaf_len-$bg+1;
			$bg = $ed-$len+1;
		}
		my $spe = (split /\./, $info)[0];
		$info =~ /^$spe\.(\S+)/;
		my $scaf = $1;
		next unless(exists $fh{$spe});
		$fh{$spe} -> print("$idx-$spe-$scaf\t$scaf\t$strand\t$bg\t$ed\n");
		$flag = 1;
	}
	$idx++ if($flag == 1);
}
close IN;

foreach my $spe (@spe){
	$fh{$spe} -> close;
}
