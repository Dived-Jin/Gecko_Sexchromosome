#/bin/bash

#######bin path
scriptp=`dirname "$(realpath $0)"`
binpath="$scriptp/bin"

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
bwa index -p $genome $genome #build index #baw v0.7.17
samtools faidx $genome
cat $samplelsf |while read sampleid fq1 fq2
do
    mkdir $sampleid
    cd $sampleid
    bwa mem $genome $fq1 $fq2 -t 5|samtools view -@ 5 -b - |samtools sort -@ 5 - >$sampleid.sort.merge.bam # samtools v1.11 , bwa v0.7.17
    samtools index $sampleid.sort.merge.bam 
    java -jar picard.jar MarkDuplicates REMOVE_DUPLICATES=true I=$sampleid.sort.merge.bam O=$sampleid.sort.rmdup.bam M=RMmarkdupt.matir TMP_DIR=`pwd`/tmp #remove duplication Java V1.81 , picard V2.23.8
    samtools index $sampleid.sort.rmdup.bam
    bamaddrg -b $sampleid.sort.rmdup.bam -s $sampleid >$sampleid.sort.rmdup.addSample.bam #add sample name #https://github.com/ekg/bamaddrg.git
    samtools index $sampleid.sort.rmdup.addSample.bam 
    mkdir bcf 
    awk '{print $1"\t"$2}' ../$genome.fai | while read chrs length 
    do
        freebayes --bam $sampleid.sort.rmdup.addSample.bam --region $chrs:1-$length -f $genome bcftools view --no-version -Oz -o >bcf/${chrs}.bcf.gz #call SNP & INDEL by freebayes V1.1.0; bedtools V1.11
        bcftools index bcf/${chrs}.bcf.gz
    done
    cd ..
done

######## Merge bcf file
mkdir Merge
awk '{print $1}' $genome.fai |while read chrs
do
    awk '{print $1}' $samplelsf |while read sample;do echo "$sample/bcf/$chrs.bcf";done >Merge/$chrs.txt
    bcftools merge -l Merge/chrs.txt  -0 -Ob -o Merge/$chrs.bcf #merge sample
    echo "Merge/$chrs.bcf"
done >merg.list
bcftools concat -nf merg.list | bcftools view -Ou -e 'type="ref"' | bcftools norm -Oz -f $genome -o $genome.group.bcf.gz # merge scaffold
bcftools index $genome.group.bcf.gz

######### Calculate Fst
grep -w -i "^male" $samplelsf |awk '{print $1}' >male_group.txt
grep -w -i "^female" $samplelsf |awk '{print $1}' >female_group.txt
vcftools --gzvcf $genome.group.bcf.gz --recode-INFO-all --max-alleles 2 --min-alleles 2 --minDP 3 --minQ 30 --recode --remove-indels --out $genome.group.vcf.filter 
vcftools --vcf $genome.genotypes.vcf.filter.recode.vcf -weir-fst-pop female_group.txt --weir-fst-pop male_group.txt --out Bin.500K --fst-window-size 500000 # Calculate Fst with 500kb length.
grep "chr" Bin.500K.windowed.weir.fst|sed 's/chr//' >all.500k.txt
Rscript $binpath/Fstplot_v2.r all.500k.txt $Special_chr Bin.500K.windowed.weir.fst.pdf Bin.500K.windowed.weir.fst.special.pdf
