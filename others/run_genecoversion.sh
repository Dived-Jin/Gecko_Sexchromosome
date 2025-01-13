#/bin/bash
#######bin path
scriptp=`dirname "$(realpath $0)"`
binpath="../$scriptp/bin"
geneconv=""

##########
importhf=""

############
mkdir Result_conversion
cat $importhf |while read line
do
    p=`dirname $line`
    mark=`basename $p`
    file="$p/cds.rmgap.phy"
    awk 'NR!=1 {print ">"$1"\n"$2}' $file >cds.rmgap.fa
    $geneconv/geneconv cds.rmgap.fa /w123 /lp -nolog
    mv cds.rmgap.frags Result_conversion/$mark.frags
done

