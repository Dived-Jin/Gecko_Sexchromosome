#!/usr/bin/perl -w
use strict;
use SVG;
use POSIX;
use File::Basename;
use Sort::Versions;

die "perl $0 <color.config> <PQTREE.gene_tab.add.add.add> <spe.chrX.info> <fa.len> <ref>" unless @ARGV == 5;

my $sp = basename($ARGV[2]);
$sp = (split /\./, $sp)[0];

my (%color, %hash, %gene, %agene, %len);
my $N = 0;
open(IN, $ARGV[0]) or die $!;
while(<IN>){
	chomp;
	my ($spe, $x, $rgb) = (split /\t/)[0,1,2];
	#next unless($spe eq $sp);
	$x =~ s/^chr//;
	if($rgb =~ /,/){
		$color{$x} = "rgb($rgb)";
	}
	else{
		$color{$x} = $rgb;
	}
	$N++;
}
close IN;

my $max_len = 0;
open(IN, $ARGV[3]) or die $!;
while(<IN>){
	chomp;
	my ($scaf, $len) = (split /\t/)[0,1];
	$scaf =~ s/^chr//;
	$len{$scaf} = $len;
	$max_len = $len if($max_len < $len);
}
close IN;

open(IN, $ARGV[2]) or die $!;
while(<IN>){
	chomp;
	my ($chr, $scaf, $bg, $ed, $beg, $end) = (split /\t/)[0,1,2,3,4,5];
	$chr =~ s/^chr//;
	$scaf =~ s/^chr//;
	$hash{$scaf} = [$chr, $bg, $ed, $beg, $end];
}
close IN;

open(IN, $ARGV[1]) or die $!;
while(<IN>){
	my $in1 = $_;
	chomp($in1);
	my @tmp = split /\t/, $in1;
	my ($h, $flag) = ('', 0);
	for(my $i=2;$i<@tmp;$i+=4){
		my ($spe, $scaf, $bg1, $ed1) = @tmp[$i..$i+3];
		if($spe eq $ARGV[4]){
			$h = $scaf;
			$h =~ s/^chr//;
			$flag = 1;
		}
	}
	next if($flag == 0);
	next unless(exists $color{$h});
	for(my $i=2;$i<@tmp;$i+=4){
		my ($spe, $scaf, $bg1, $ed1) = @tmp[$i..$i+3];
		$scaf =~ s/^chr//;
		if($spe eq $sp){
			($bg1, $ed1) = $bg1 > $ed1 ? ($ed1, $bg1) : ($bg1, $ed1);
			next unless(exists $hash{$scaf});
			my ($x, $bg, $ed, $beg, $end) = @{$hash{$scaf}};
			my $bg1_new = $bg1-$bg+$beg;
			my $ed1_new = $ed1-$bg+$beg;
			push @{$agene{$x}}, [$color{$h}, $bg1_new, $ed1_new];
		}
	}
}
close IN;

foreach my $scaf (sort keys %agene){
	@{$agene{$scaf}} = sort {$a->[1] <=> $b->[1]} @{$agene{$scaf}};
}

my $car_num = keys %len;
my $h_rate = 500000;
my $w_rate = 60;
my $width = ($car_num+1)*$w_rate;
my $height = ceil($max_len/$h_rate)+50;
my $num = int(keys %hash);
#print "$num\t$width\t$height\n";
my $svg = SVG->new('width', $width, 'height', $height);
my ($leftBar, $topBar) = (25, 25);

my $text = $svg->group(id=>'name', style=>{'font-family'=>"Arial", 'fill'=>'black'});
my $car = $svg->group(id=>'car', style=>{'stroke'=>'black', 'stroke-width'=>1, 'fill'=>'white'});
my $block = $svg->group(id=>'block');

my $n = 0;
foreach my $car (sort {$a<=>$b or $a cmp $b} keys %color){
	$block->rect(x=>$width-100, y=>$height-(21*$N-$n*20), width=>12, height=>12, 'fill'=>$color{$car}, 'stroke'=>$color{$car});
	$text->text(x=>$width-80, y=>$height-(21*$N-$n*20-10), '-cdata'=>"$car", 'font-size'=>12);
	$n++;
}

my $line_y1 = $leftBar;
#foreach my $scaf (sort {$a <=> $b or $a cmp $b} keys %agene){
foreach my $scaf (sort {versioncmp($a, $b)} keys %agene){
	$text->text(x=>$line_y1, y=>$topBar, '-cdata'=>"$scaf");
	$car->rect(x=>$line_y1, y=>$topBar+5, width=>24, height=>$len{$scaf}/$h_rate);
	for(my $i=0;$i<@{$agene{$scaf}};$i++){
		my ($rgb, $bg, $ed) = @{$agene{$scaf}[$i]};
		#die "$gene, $bg, $ed";
		#next unless(exists $agene{$gene});
		my $size = ($ed-$bg+1)/$h_rate;
		$bg = $bg/$h_rate;
		#my $rgb = $color{$};
		$block->rect(x=>$line_y1+1, y=>$topBar+5+$bg, width=>22, height=>$size, 'fill'=>$rgb, 'stroke'=>$rgb);
	}
	$line_y1 += $w_rate-24;
}

print $svg->xmlify();


