#!/bin/usr/perl -w
use strict;
use Getopt::Long;
use File::Basename;

my ($slice, $spe, $help);
GetOptions(
    "s|slice!"=>\$slice,
    "spe:s"=>\$spe,
    "help"=>\$help
);


die "perl $0 [-slice] -spe GALGA <maf> <bed> > result.maf\n" if (@ARGV != 2 || $help);

my $maf_file = shift;
my $bed_file = shift;

my %hash;
my ($bed,$maf,@all_maf,$chr,$start,$end);

open(BED,$bed_file)||die"$!\n";
open(MAF,$maf_file)||die"$!\n";

while(<BED>){
	chomp;
	my ($contig, $start, $end) = (split /\t/)[0,1,2];
	$start++;
	push @{$hash{$contig}}, [$start, $end];
}
close BED;

$/="a score=";
my $head=<MAF>;
chomp $head;
print "$head";
while(<MAF>){
	chomp;
	my @all_maf = split /\n/;
	my $score = shift @all_maf;
	while($all_maf[0] =~ /^#/){
		pop @all_maf;
	}

	my $info;
	foreach (@all_maf){
		$info = $_ if(/^s $spe\./);
	}
	die "$spe\.\n@all_maf\n" unless(defined $info);

	my ($contig, $bg, $len, $strand, $totlen, $seq) = (split /\s+/, $info)[1,2,3,4,5,6];
	$bg++;
	$contig =~ s/^$spe\.//;

	next unless(exists $hash{$contig});

	my $ed;
	if($strand eq '+'){
		$ed = $bg+$len-1;
	}
	else{
		$ed = $totlen-$bg+1;
		$bg = $ed-$len+1;
	}
	
	my %idx;
	my @seq = split //, $seq;
	if($strand eq '+'){
		my $pos = $bg;
		for(my $i=0;$i<@seq;$i++){
			next if($seq[$i] eq '-');
			$idx{$pos} = $i;
			$pos++;
		}
	}
	else{
		my $pos	= $bg;
		for(my $i=$#seq;$i>=0;$i--){
			next if($seq[$i] eq '-');
			$idx{$pos} = $i;
			$pos++;
		}
	}
	
	foreach my $range (@{$hash{$contig}}){
		my ($start, $end) = @{$range};
    	my ($get_start, $get_end, $lable) = &overlap($start, $end, $bg, $ed);
        next if ($get_start == 0 && $get_end == 0);
		
		if(defined $slice){
			print "a score=$score\n";	
			my $sidx = $idx{$get_start};
			my $eidx = $idx{$get_end};
			#print STDERR "$strand\n$sidx, $eidx\n$get_start, $get_end\n$start, $end, $bg, $ed\n";
			($sidx, $eidx) = ($eidx, $sidx) if($sidx > $eidx);
			my $l = $eidx-$sidx+1;
			foreach my $info (@all_maf){
				my ($contig, $bg, $len, $strand, $totlen, $seq) = (split /\s+/, $info)[1,2,3,4,5,6];
				my $tmp = substr($seq, 0, $sidx+1);
				$tmp =~ s/-//g;
				$bg += length($tmp)-1;
				$seq = substr($seq, $sidx, $l);
				
				$tmp = $seq;
				$tmp =~ s/-//g;
				$len = length($tmp);
				
				my $out = join " ", 's', $contig, $bg, $len, $strand, $totlen, $seq;
				print "$out\n";
				#printf "%-1s %-22s %13s %-8s %-2s %-13s %s\n", $contig, $bg, $len, $strand, $totlen, $seq;
			}
			print "\n";
		}
		else{
			print "a score=$_";
			
		}
	}
}

sub overlap {
    my ($s, $e, $rs, $re) = @_;
    if ($e<$rs){
        return (0,0,1);
    }elsif($s<=$rs && $e>=$rs && $e<=$re){
        return ($rs,$e,1);
    }elsif($s<=$rs && $e>=$re){
        return ($rs,$re,2);
    }elsif($s>=$rs && $e<=$re){
        return ($s,$e,1);
    }elsif($s>=$rs && $s<=$re && $e>=$re){
        return ($s,$re,2);
    }elsif($s>$re){
        return (0,0,2);
    }else{
        die "Error:$s,$e,$rs,$re\n";
    }
}

