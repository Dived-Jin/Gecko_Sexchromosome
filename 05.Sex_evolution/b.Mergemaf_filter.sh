#/bin/bash
#######bin path
scriptp=`dirname "$(realpath $0)"`
binpath="$scriptp/bin"
maffiterpath="" # maffilter path 

######### Raw input
Genomepath= "" # genome file path
Spnname="../species.txt"
gengffpath=""  #gene annotation file path 
TRFpath="" # repeat gff file path
homopath="" #repeat gff file path
denovopath="" #repeat gff file path 
nowdir=`pwd`

########################################
function GenerateBed(){
    spn1=$1
    Mars=$2
    infile=$3
    outfile=$4
    fulln=`grep $spn1 $Spnname |awk '{print $1}'`
    faifile=$Genomepath/$fulln.fa.fai
    genegffile=$Gffpath/$fulln.gene.gff
    TRFrepeatf=$TRFpath/$fulln.TRF.gff
    homorepeatf=$homopath/$fulln.homo.gff
    denovorepeatf=$denovopath/$fulln.denovo.gff
    rm -rf genome.size
    cat $TRFrepeatf $homorepeatf $denovorepeatf |awk '{print $1"\t"$4-1"\t"$5}' >Repead.bed
    grep "^s $Mars" $infile |awk -F "[ .]" '{print $3}'|sort|uniq |while read chrs;do grep -w $chrs Repead.bed;done >Repeatchr.bed
    grep "^s $Mars" $infile |awk -F "[ .]" '{print $3}'|sort|uniq |while read chrs
    do
        chrlength=`grep -w $chrs $faifile|awk '{print $2}'`
        echo -e "$chrs\t$chrlength" >>genome.size
        grep -w $chrs $gffile |grep -w "CDS" | awk '{print $4-2001"\t"$5+2000}' |while read Stars End
        do
            if [ $Stars -lt 0 ];then
                Stars=1
            fi
            if [ $End -gt $chrlength ];then
                End=$chrlength
            fi
            echo -e "$chrs\t$Stars\t$End"
        done
    done | sort -k1,1V -k2,2n |bedtools merge -i - >tmpa.bed #|awk '{print $1"\tkept\tmRNA\t"$2"\t"$3"\t.\t+\t.\tID=kepID"NR";"}' >$outfile
    cat tmpa.bed Repeatchr.bed |sort -k1,1V -k2,2n bedtools merge -i - >tmpb.bed
    sort -k1,1V genome.size >genome.sort.size
    bedtools complement -i tmpb.bed -g genome.sort.size |awk '{print $1"\tkept\tmRNA\t"$2+1"\t"$3"\t.\t+\t.\tID=kepID"NR";"}'>$outfile
}

###############################################################################

function GetMaf(){
    mark=$1
    bedfile=$2
    inputmaf=$3
    outmaf=$4
    echo -e "input.file=$inputmaf
input.file.compression=none
input.format=Maf
output.log=test.log
maf.filter= \\
        ExtractFeature(ref_species=$mark, \\
                feature.file=${bedfile}, \\
                feature.file.compression=none, \\
                feature.format=GFF, \\
                feature.type=all, \\
        complete=no, \\
        ignore_strand=no), \\
                Output(file=${outmaf}, \\
        compression=none)" >control_file
    $maffiterpath/maffilter param=control_file
}
################################################################################
nowdir=`pwd`
cat $1 |while read line
do
    arra=(${line// / })
    Mark=${arra[1]}
    Markls=(${Mark//_/ })
    #spk2=`echo $line|awk '{for(i=2;i<=NF;i++){if(i!=NF){printf $i","}else{printf $i}}}'`
    #spk1=`echo $Mark|awk -F "_" '{for(i=1;i<=NF;i++){printf $i","$i"_ZW,"}}'`
    #Allspnk="$spk1$spk2"
    inputraw1=${arra[0]}
    cat $inputraw1 >$nowdir/$Mark/Rm1.maf
    for spn1 in ${Markls[@]}
    do
        echo $spn1
        GenerateBed $spn1 "${spn1}" $inputraw1 $nowdir/$Mark/nonconds.bed
    python $binpath/keepMaf.py $spn1 $nowdir/$Mark/Rm1.maf kept1.maf
        GetMaf $spn1 $nowdir/$Mark/nonconds.bed $nowdir/$Mark/Rm1.maf $nowdir/$Mark/Rm2.maf
    ls -l $nowdir/$Mark/Rm2.maf
        cat $nowdir/$Mark/Rm2.maf kept1.maf >$nowdir/$Mark/Rm1.maf
    ls -l  $nowdir/$Mark/Rm1.maf
    python $binpath/keepMaf.py ${spn1}_WY $nowdir/$Mark/Rm1.maf kept1.maf
        GetMaf ${spn1}_WY $nowdir/$Mark/nonconds.bed $nowdir/$Mark/Rm1.maf $nowdir/$Mark/Rm2.maf
    ls -l $nowdir/$Mark/Rm2.maf
        cat $nowdir/$Mark/Rm2.maf kept1.maf >$nowdir/$Mark/Rm1.maf
    ls -l  $nowdir/$Mark/Rm1.maf
    done
    for((i=2;i<${#arra[@]};i++))
    do
        spn2=${arra[i]}
        echo $spn2
        GenerateBed $spn2 "$spn2" $inputraw1 $nowdir/$Mark/nonconds.bed
    python $binpath/keepMaf.py $spn2 $nowdir/$Mark/Rm1.maf kept1.maf
        GetMaf $spn2 $nowdir/$Mark/nonconds.bed $nowdir/$Mark/Rm1.maf $nowdir/$Mark/Rm2.maf
        cat $nowdir/$Mark/Rm2.maf kept1.maf >$nowdir/$Mark/Rm1.maf
    done
    mv $nowdir/$Mark/Rm1.maf $nowdir/$Mark/$Mark.noncoding.maf
done
