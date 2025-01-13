#/bin/bash
#######bin path
scriptp=`dirname "$(realpath $0)"`
binpath="$scriptp/bin"
lastpath="" # last path
lastZpath="" #lastZ path 
multizpath= "" #multiz path
############### raw input
nowdir=`pwd`
#CORSAR_CORCIL  PYGNIG  NEPLEV  COLBRE
genomepath="" #include two cloumns; spn, genmome path 

############### get raw sequence & alignment
mkdir LAST
cd LAST
for f in $scriptp/example/*.txt
do
    dirk=`basename $f|awk -F "[_.]" '{print $1}'`
    types=`basename $f|awk -F "[_.]" '{print $2}'`
    genomef=`grep $dirk $genomepath`
    mkdir $dirk
    python $binpath/Getche_sequence.py $f $genomef $dirk/${dirk}_${types}.sexh.MN.fasta
done

$lastpath/lastdb -R11 -P10 -c -uMAM8  CORSAR/HomGam CORSAR/CORSAR_chrZ.sexh.MN.fasta #make alignment db 
for f in $nowdir/LAST/*/*.sexh.MN.fasta 
do
    if [ `baseame $f` != "CORSAR_chrZ.sexh.MN.fasta" ];then 
        ldirn=`dirname $f`
        typs=`baseame $f|awk -F "[_.]" '{print $2}'`
        workshell=$ldirn/lasta${typs}.sh
        mkdir $ldirn/Lastrun${typs}
        echo "cd $ldirn/Lastrun${typs}" >$workshell
        echo "$lastpath/last-train -R11 --revsym -D1e9 --sample-number=5000 -P10 $nowdir/LAST/CORSAR/HomGam $f" >>$workshell
        echo "$lastpath/lastal -R11 -P10 -D1e9 -m100 --split-f=MAF -p HomGam.train  $nowdir/LAST/CORSAR/HomGam $f1 >many-to-one.maf" >>$workshell
        echo "$lastpath/last-split -r many-to-one.maf | $lastpath/last-postmask >out.maf" >>$workshell
        echo "sh Trasmaf${typs}.sh" >>$workshell
        echo "cd $nowdir/LAST"
        sh $binpath/LastMaftran.sh $ldirn/Lastrun${typs} $nowdir/LAST/CORSAR//CORSAR_chrZ.sexh.MN.fasta $f $ldirn/Lastrun${typs}/out.maf $typs 
        sh $workshell
    fi
done
cd .. 

######################## Merge MAF file
mkdir $nowdir/CORSAR_CORCIL
cd $nowdir/CORSAR_CORCIL
sed 's/target./CORSAR./' ../LAST/CORCIL/LastrunchrZ/TransfchrZ/out.Net2maf.add.maf|sed 's/query./CORCIL./' >tmp1.maf 
sed 's/target./CORSAR./' ../LAST/CORCIL/LastrunchrW/TransfchrW/out.Net2maf.add.maf|sed 's/query./CORCIL_WY./' >tmp2.maf
$multizpath/multiz tmp1.maf tmp2.maf 1 tmp1.maf.u.mp tmp2.maf.u.mp >CORCIL.mp && grep -v -h eof CORCIL.mp tmp1.maf.u.mp tmp2.maf.u.mp >CORCIL.mp.U && $multizpath/maf_project CORCIL.mp CORSAR CORCIL.mp.U.0 >CORCIL.U.maf 
sed 's/target./CORSAR./'  ../LAST/CORSAR/LastrunchrW/TransfchrW/out.Net2maf.add.maf|sed 's/query./CORSAR_WY./' >tmp1.maf
$multizpath/multiz  tmp1.maf CORCIL.U.maf 1 tmp1.maf.u.mp tmp2.maf.u.mp >COR.mp && grep -v -h eof COR.mp tmp1.maf.u.mp tmp2.maf.u.mp >COR.mp.U && $multizpath/maf_project COR.mp.U CORSAR COR.mp.U.0 >COR.U.maf 
sed 's/target./CORSAR./' ../LAST/PYGNIG/LastrunAutosome/TransfAutosome/out.Net2maf.add.maf|sed 's/query./PYGNIG./' >tmp1.maf 
sed 's/target./CORSAR./' ../LAST/NEPLEV/LastrunchrZ/TransfchrZ/out.Net2maf.add.maf|sed 's/query./NEPLEV./'>tmp2.maf
$multizpath/multiz tmp1.maf tmp2.maf 1 tmp1.maf.u.mp tmp2.maf.u.mp >PYGNEP.mp && grep -v -h eof PYGNEP.mp tmp1.maf.u.mp tmp2.maf.u.mp >PYGNEP.mp.U && $multizpath//maf_project PYGNEP.mp.U CORSAR PYGNEP.mp.U.0 >PYGNEP.U.maf 
$multizpat/multiz COR.U.maf PYGNEP.U.maf 1 COR.U.maf.u.mp PYGNEP.U.maf.u.mp >COR-PYGNEP.mp && grep -v -h eof COR-PYGNEP.mp COR.U.maf.u.mp PYGNEP.U.maf.u.mp >COR-PYGNEP.mp.U && $multizpath//maf_project COR-PYGNEP.mp.U CORSAR COR-PYGNEP.mp.U.0 >COR-PYGNEP.U.maf 
sed 's/target./CORSAR./' ../LAST/COLBRE/LastrunAutosome/TransfAutosome/out.Net2maf.add.maf|sed 's/query./COLBRE./'>tmp1.maf
$multizpat/multiz COR-PYGNEP.U.maf tmp1.maf 1 COR-PYGNEP.U.maf.u.mp tmp1.maf.u.mp >COR-PYGNEP-COL.mp && grep -v -h eof COR-PYGNEP-COL.mp COR-PYGNEP.U.maf.u.mp tmp1.maf.u.mp >COR-PYGNEP-COL.mp.U && $multizpath//maf_project COR-PYGNEP-COL.mp.U CORSAR COR-PYGNEP-COL.mp.U.0 >COR-PYGNEP-COL.U.maf
