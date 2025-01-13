#/bin/bash

#######bin path
scriptp=`dirname "$(realpath $0)"`
binpath="$scriptp/bin"
Toolspath="" #the path of bwa, samtools, picard.jar, bamaddrg, freebayes and son on.

############# Raw input 
# sample.list format
# male1 fq1 fq2
# male2 fq1 fq2
# male3 fq1 fq2
# female1 fq1 fq2
# female2 fq1 fq2
# female2 fq1 fq2

genome=$1
Special_chr=$2
samplelsf=$3

###################alignment and deal maf file
$Toolspath/bwa index -p $genome $genome #build index #baw v0.7.17
$Toolspath/samtools faidx $genome
cat $samplelsf |while read sampleid fq1 fq2
do
    mkdir $sampleid
    cd $sampleid
    $Toolspath/bwa mem $genome $fq1 $fq2 -t 5|$Toolspath/samtools view -@ 5 -b - |$Toolspath/samtools sort -@ 5 - >$sampleid.sort.merge.bam # samtools v1.11 , bwa v0.7.17
    $Toolspath/samtools index $sampleid.sort.merge.bam 
    java -jar $Toolspath/picard.jar MarkDuplicates REMOVE_DUPLICATES=true I=$sampleid.sort.merge.bam O=$sampleid.sort.rmdup.bam M=RMmarkdupt.matir TMP_DIR=`pwd`/tmp #remove duplication Java V1.81 , picard V2.23.8
    $Toolspath/samtools index $sampleid.sort.rmdup.bam
    $Toolspath/bamaddrg -b $sampleid.sort.rmdup.bam -s $sampleid >$sampleid.sort.rmdup.addSample.bam #add sample name #https://github.com/ekg/bamaddrg.git
    $Toolspath/samtools index $sampleid.sort.rmdup.addSample.bam 
    mkdir bcf 
    awk '{print $1"\t"$2}' ../$genome.fai | while read chrs length 
    do
        $Toolspath/freebayes --bam $sampleid.sort.rmdup.addSample.bam --region $chrs:1-$length -f $genome |$Toolspath/bcftools view --no-version -Oz -o >bcf/${chrs}.bcf.gz #call SNP & INDEL by freebayes V1.1.0; bedtools V1.11
        $Toolspath/bcftools index bcf/${chrs}.bcf.gz
    done
    cd ..
done

######## Merge bcf file
mkdir Merge
awk '{print $1}' $genome.fai |while read chrs
do
    awk '{print $1}' $samplelsf |while read sample;do echo "$sample/bcf/$chrs.bcf";done >Merge/$chrs.txt
    $Toolspath/bcftools merge -l Merge/chrs.txt  -0 -Ob -o Merge/$chrs.bcf #merge sample
    echo "Merge/$chrs.bcf"
done >merg.list
$Toolspath/bcftools concat -nf merg.list | $Toolspath/bcftools view -Ou -e 'type="ref"' | $Toolspath/bcftools norm -Oz -f $genome -o $genome.group.bcf.gz # merge scaffold
$Toolspath/bcftools index $genome.group.bcf.gz

######### Calculate Fst
grep -w -i "^male" $samplelsf |awk '{print $1}' >male_group.txt
grep -w -i "^female" $samplelsf |awk '{print $1}' >female_group.txt
$Toolspath/vcftools --gzvcf $genome.group.bcf.gz --recode-INFO-all --max-alleles 2 --min-alleles 2 --minDP 3 --minQ 30 --recode --remove-indels --out $genome.group.vcf.filter 
$Toolspath/vcftools --vcf $genome.genotypes.vcf.filter.recode.vcf -weir-fst-pop female_group.txt --weir-fst-pop male_group.txt --out Bin.500K --fst-window-size 500000 # Calculate Fst with 500kb length.
grep "chr" Bin.500K.windowed.weir.fst|sed 's/chr//' >all.500k.txt
Rscript $binpath/Fstplot_v2.r all.500k.txt $Special_chr Bin.500K.windowed.weir.fst.pdf Bin.500K.windowed.weir.fst.special.pdf
