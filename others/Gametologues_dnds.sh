#/bin/bash
#######bin path
scriptp=`dirname "$(realpath $0)"`
binpath="$scriptp/bin"

##Raw inoput 
Pairwisef=$1
inputpep=`realpath $2`
inputcds=`realpath $3`

#############
mkdir ds_freeratio
nowdir=`pwd`
ids=0
cat $Pairwisef |while read chrXZ chrYW
do
    ids=`expr $ids + 1 `
    outp=ds_freeratio/$ids
    if [ ! -d $outp ];then
        mkdir -p $outp
    fi
    echo -e "$chrXZ\tX$chrYW\t$Y" >$outp/in.list
    echo "(X,Y);" >$outp/tree.nwk 
    workshell="$outp/runcodeml.sh"
    echo "cd $nowdir/$outp" >$workshell
    echo "python $binpath/get.py in.list $inputcds in.cds" >>$workshell
    echo "python $binpath/get.py in.list $inputpep in.pep" >>$workshell
    echo "prank -d=in.pep -t=tree.nwk -F -o=prank" >>$workshell
    echo "perl pepMfa_to_cdsMfa.pl prank.best.fas in.cds >cds.prank.align" >>$workshell
    echo "python mfa_to_phy.py cds.prank.align prank.cds.phy fasta phylip-sequential" >>$workshell 
    echo "cp $scriptp/example/codeml.ctl $nowdir/$outp" >>$workshell
    echo "codeml codeml.ctl" >>$workshell
done

for f in ds_freeratio/*/runcodeml.sh;do sh $f;done 
for f in ds_freeratio/*/in.list
do
    mark=`awk '{print $1}' $f|xargs`
    dir=`dirname $f`
    k=`tail -1 $dir/codeml.cds |awk '{print $NF}'`
    echo -e "$mark\t$k"
done >ds.stat.txt

