#/bin/bash
#######bin path
scriptp=`dirname "$(realpath $0)"`
binpath="../$scriptp/bin"
kallistopath="" #kallisto path

################## Rawinput 
inpucds=`realpath $1`
inputgff=`realpath $2`
fqlsf=$3
outdir=$4
nowdir=`pwd`
################# Raw TMP calculated

mkdir -p $outdir/index
cd $outdir/index
$kallistopath/kallisto index -i $inpucds.index $inpucds
cd ..
mkdir kallisto 
cat sample_all.list |while read line
do
    arra=(${line// / })
    tissue=${arra[0]}
    outp="$nowdir/kallisto/$tissue"
    if [ ! -d $outp ];then
        mkdir -p $outp
    fi
    outshell="$outp/RunKallisto.sh"
    indexf="$nowdir/index/$inpucds.index"
    echo "cd $outp" >$outshell
    if [ "$seqty" == "SINGLE" ];then
        fq=${arra[1]}
        echo "$kallistopath/kallisto quant -i $indexf -o $outp --bias -l 100 -s 300 -t 5 --single $fq" >>$outshell
    else
        fq1=${arra[1]}
        fq2=${arra[2]}
        echo "$kallistopath/kallisto quant -i $indexf -o $outp --bias -t 5 $fq1 $fq2" >>$outshell
    fi
    sh $outshell
done

for f in kallisto/*/abundance.tsv;do n=`echo $f |awk -F "/" '{print $(NF-1)}'`; ln -s $f $n.tsv;done
ls *.tsv | while read i; do perl $binpath/kallisto_to_count.pl $i > $i.count; done
Rscript $binpath/htseq-merge_all.R ./ all.output
ls *.tsv.count | while read i; do j=`echo $i | sed 's/.tsv.count//' | sed 's/_/\t/'`; echo -e "$i\t$j"; done > metadata.txt
cat all.output.count | awk '!/^__/' > all.output.count.filt
Rscript $binpath/DESeq2.r all.output.count.filt metadata.txt all.output.count.filt.norm # normalized between samples 
perl $binpath/gff2gtf.pl $inputgff >all.gtf
perl $binpath/add_zeros.pl all.output.count.filt all.output.count.filt.norm > all.output.count.filt.norm.add
perl $binpath/get_transcript_length.pl all.gtf >all.gtf.len
perl $binpath/AddColumn.v2.pl all.output.count.filt.norm.add all.gtf.len 1 >all.output.count.filt.norm.add.add
Rscript $binpath/calculate_TPM.r all.output.count.filt.norm.add.add all.output.count.filt.norm.add.add.tpm

################## TAU 

