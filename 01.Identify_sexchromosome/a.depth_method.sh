#/bin/bash
#######bin path
scriptp=`dirname "$(realpath $0)"`
binpath="$scriptp/bin"
Toolspath="" # the path of samools, bedtools, bwa

############# Raw input
geneome=$1
sexty=$2
malefq1=$3
malefq2=$4
female=$5
female=$6

############# alignment
$Toolspath/bwa index -p $genome $genome #build index #baw v0.7.17
$Toolspath/bwa mem $genome $malefq1 $malefq2 -t 5 |samtools view -@ 5 -b - |samtools sort -@ 5 - >$genome.male.sort.bam # male WGS alignment # samtools v1.11, bwa V0.7.17 
$Toolspath/bwa mem $genome $femalefq1 $femalefq2 -t 5 |samtools view -@ 5 -b - |samtools sort -@ 5 - >$genome.female.sort.bam # female WGS alignment

############extract sequence
$Toolspath/samtools faidx $genome
$Toolspath/bedtools makewindows -g $genome.fai -w 50000  >chr.50k.bed ## split windown with 50kb #bedtools v2.29.2
awk -F " " '{print $1"\t0\t"$2}' $genome.fai >chr.region.bed
$Toolspath/samtools depth -b chr.region.bed $genome.male.sort.bam |gzip >male.depth.bed.gz # male sequence depth file of all site
$Toolspath/samtools depth -b chr.region.bed $genome.female.sort.bam |gzip >female.depth.bed.gz # female sequence depth file all site
zcat male.depth.bed.gz | awk '{print $1"\t"$2-1"\t"$2"\t"$3}' | awk '$4>0' |gzip >male.depth.bed.filer.gz
zcat female.depth.bed.gz | awk '{print $1"\t"$2-1"\t"$2"\t"$3}' | awk '$4>0' |gzip >female.depth.bed.filer.gz

#####normalized the sequence depth by 50kb windowns
zcat male.depth.bed.filer.gz| $Toolspath/bedtools map -a chr.50k.bed -b - -c 4 -o median,mean,count >male.50k.cov
zcat female.depth.bed.filer.gz| $Toolspath/bedtools map -a chr.50k.bed -b - -c 4 -o median,mean,count >female.50k.cov
paste male.50k.cov female.50k.cov | cut -f1-6,10- > FMmerge.50k.cov ### merge male and female sequence depth

####calculate the sequence depth of male and female respectivaly.
zcat male.depth.bed.gz | awk -F " " '{a[$3]+=1}END{for(i in a){print i"\t"a[i]}}' >male.depth.frequence
zcat female.depth.bed.gz | awk -F " " '{a[$3]+=1}END{for(i in a){print i"\t"a[i]}}' >female.depth.frequence
MaleDep=`sort -k2,2rn male.depth.frequence |head -1 | awk -F " " '{print$1}'`
FemaleDep=`sort -k2,2rn female.depth.frequence |head -1 | awk -F " " '{print $1}'`

#####nomalized & compared male and female depth
perl $binpath/normalize_calculateRatio.pl FMmerge.50k.cov $MaleDep $FemaleDep $sexty >FMmerge.50k.cov.ratio
python $binpath/format_summary.py FMmerge.50k.cov.ratio 1.5 2.5 0.3 $genome.fai $sexty >FMmerge.50k.cov.ratio.class

#####extracted Sex chromosome region
if [ "$sexty" == "ZW" ];then
    grep ">" FMmerge.50k.cov.ratio.class | awk '$9=="Z"' | sort -k2,2nr | sed 's/^>//' | awk '$2>=10000 && $4>0.6' > FMmerge.50k.cov.ratio.class.Z.tab
    grep ">" FMmerge.50k.cov.ratio.class | awk '$9=="W"' | sort -k2,2nr | sed 's/^>//' | awk '$2>=10000 && $6>0.6' > FMmerge.50k.cov.ratio.class.W.tab
else
    grep ">" FMmerge.50k.cov.ratio.class | awk '$9=="X"' | sort -k2,2nr | sed 's/^>//' | awk '$2>=10000 && $4>0.6' > FMmerge.50k.cov.ratio.class.Z.tab
    grep ">" FMmerge.50k.cov.ratio.class | awk '$9=="Y"' | sort -k2,2nr | sed 's/^>//' | awk '$2>=10000 && $6>0.6' > FMmerge.50k.cov.ratio.class.W.tab
fi
#####candidated Sex scaffold
grep ">" FMmerge.50k.cov.ratio.class | awk '($3>=50000 && $4>=0.2) || ($5>=50000 && $6>=0.2)' | awk '$9!="Z" && $9!="W"' | sort -k2,2nr | sed 's/^>//' > check.lst
grep ">" FMmerge.50k.cov.ratio.class | awk '$9=="Z" || $9=="W"' | sort -k2,2nr | awk '$7>=50000' | sed 's/^>//' >> check.lst
perl $binpath/pick.column_info.pl check.lst FMmerge.50k.cov.ratio  1 1 -t same >FMmerge.50k.cov.ratio.filt
perl $binpath/prepare_plot.info.filter.nor.pl FMmerge.50k.cov.ratio.filt plotfilt ZW
ls plotfilt/*.norm | while read i;do Rscript $binpath/plot_ratio_scaffold.R $i $i.pdf $sexty;done

#####check SDR boundary by manully & create manual_check.nonPARW.bed and manual_check.nonPARZ.bed

######merge all result
for f in manual_check.nonPA*.bed;do sed -i 's/\s\+/\t/g' $f;done
perl $binpath/pick.column_info.pl manual_check.nonPARZ.bed FMmerge.50k.cov.ratio.class.Z.tab 1 1 -t diff | awk '{print $1"\t0\t"$2}' > nonPARZ.bed
cat manual_check.nonPARZ.bed >>nonPARZ.bed
perl $binpath/pick.column_info.pl manual_check.nonPARW.bed FMmerge.50k.cov.ratio.class.W.tab 1 1 -t diff | awk '{print $1"\t0\t"$2}' > nonPARW.bed
cat manual_check.nonPARW.bed >>nonPARW.bed
cat manual_check.PAR.bed > PAR.bed
ls nonPARZ.bed nonPARW.bed PAR.bed | while read i; do echo $i; awk 'BEGIN{tot=0}{tot+=$3-$2}END{print tot}' $i; done >Region.stats

if [ "$sexty" == "XY" ];then
    mv nonPARZ.bed nonPARX.bed
    mv nonPARW.bed nonPARY.bed
fi
