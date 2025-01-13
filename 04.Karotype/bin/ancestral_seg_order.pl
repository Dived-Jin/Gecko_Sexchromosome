#!/usr/bin/perl -w
use strict;
use Data::Dumper;

die "perl $0 <Conserved.Segments.filt.fix> <PQTREE> <spe_lst>" unless @ARGV == 3;

my (%hash, %spe);
my @spe = split /-/, $ARGV[2];
foreach (@spe){
	$spe{$_} = 1;
}

open(IN, $ARGV[0]) or die $!;
$/ = "\n\n";
while(<IN>){
	chomp;
	my @tmp = split /\n/;
	my $id = shift @tmp;
	$id =~ s/^>//;
	foreach my $info (@tmp){
		$info =~ /(\w+?)\.(\S+):(\d+)-(\d+) ([+-])/;
		my ($spe, $chr, $bg, $ed, $strand) = ($1, $2, $3, $4, $5);
		$hash{$id}{$spe} = [$chr, $bg, $ed, $strand] unless(exists $hash{$id}{$spe});
	}
}
close IN;

$/ = "\n";
my $idx = 1;
open(IN, $ARGV[1]) or die $!;
while(<IN>){
	chomp;
	next if(/^>/ || /^#/);
	s/_//g;
	s/P//g;
	s/Q//g;
	s/\s+\$$//;
	s/^\s+//;
	s/\(//g;
	s/\)//g;
	my @tmp = split /\s+/;
	foreach my $id (@tmp){
		my $strand1 = $id =~ /-/ ? '-' : '+';
		my $id1 = $id;
		$id1 =~ s/-//;
		my %sort;
		my $n;
		print "$idx\t$id";
		foreach my $spe (sort keys %spe){
			$hash{$id1}{$spe} = ['NA', 'NA', 'NA', 'NA'] unless(exists $hash{$id1}{$spe});
			my $out = join "\t", @{$hash{$id1}{$spe}}[0..2];
			print "\t$spe\t$out";
		}
		print "\n";
	}
	$idx++;
}
close IN;

