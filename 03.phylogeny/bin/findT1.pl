#!/bin/usr/perl -w
use strict;

my $result_dir = shift;

#open (LOG,">","c2.log");
opendir DIR,$result_dir;
my @files = readdir DIR;
close DIR;
foreach my $f (@files)
{
    next unless ($f =~ /Out.csv/);
    open IN,"$result_dir/$f";
    my $index = $1 if ($f =~ /Out.csv.(\d+)/);
    my $total_tree = 0;
    my %hash;
	<IN>;
    while (<IN>)
    {
		
        chomp;
        my @a = split /,/,$_;
    	$hash{$a[0]}{$a[1]}=$a[10];
	}
	my $name;
	my $n=1;
	for my $key (sort keys %hash){
		print "$key $n ";
		$n++;
		for my $out (sort {$hash{$key}{$b}<=>$hash{$key}{$a}} keys %{$hash{$key}}) {
			print "$out ";
		}
		print "\n";
	}
    close IN;
}

