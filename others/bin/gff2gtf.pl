#!/bin/perl -w
use strict;

die "perl $0 <gff>" unless @ARGV == 1;

open(IN, $ARGV[0]) or die $!;
while(<IN>){
	chomp;
	my @tmp = split /\t/;
	if($tmp[2] eq 'mRNA'){
		$tmp[8] =~ /ID=(\S+?);/;
		my $id = $1;
		my $out1 = join("\t", @tmp[0,1], 'gene', @tmp[3..7], "gene_id \"$id\"; gene_name \"$id\"; transcript_id \"$id\"; transcript_name \"$id\";");
		print "$out1\n";
		my $out2 = join("\t", @tmp[0,1], 'transcript', @tmp[3..7], "gene_id \"$id\"; gene_name \"$id\"; transcript_id \"$id\"; transcript_name \"$id\";");
		print "$out2\n";
	}
	else{
		$tmp[8] =~ /Parent=(\S+?);/;
		my $id = $1;
		my $out1 = join("\t", @tmp[0,1], 'exon', @tmp[3..7], "gene_id \"$id\"; gene_name \"$id\"; transcript_id \"$id\"; transcript_name \"$id\";");
		print "$out1\n";
		my $out2 = join("\t", @tmp[0..7], "gene_id \"$id\"; gene_name \"$id\"; transcript_id \"$id\"; transcript_name \"$id\";");
		print "$out2\n";
	}
}
close IN;

