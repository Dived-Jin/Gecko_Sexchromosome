#/bin/bash
#######bin path
scriptp=`dirname "$(realpath $0)"`
binpath="$scriptp/bin"
Quiblepath="" #download from https://github.com/miriammiyagi/QuIBL.git

#########Raw input
Seedlist=$1
Treeseedls=$2
phygeny=$3
nowdir=`pwd`

#########run Quible

for i in {1..500}
do
        outp1="$nowdir/Struct1/t$i"
        mkdir -p $outp1
        python $binpath/getseq.py $Seedlist $Treeseedls 1000 $outp1/input.tree $outp1/inputtree.infor
        cp $scriptp/example/sampleInputFile.txt $outp1/sampleInputFile.txt
        cd $outp1
        python $Quiblepath/cython_vers/QuIBL_cyth.py  sampleInputFile.txt 1>1.log 2>2.log
done

###########out csv 
inoutp=$nowdir/inout
mkdir $inoutp 
for f in $nowdir/Struct1/t*
do
    IDS=`echo $f|awk -F "t" '{print $NF}'`
    cp $f/Out.csv $inoutp/Out.csv.$IDS
done

############# Statistic
outp1=$nowdir/1.T1
mkdir -p $outp1 
cd $outp1
ln -s $inoutp ./ 
perl $binpath/findT1.pl inout >alltriplet
awk -F " " '{print $3,$4,$5}' alltriplet |sort |uniq -c|sort -nr|awk '{print $2,$3,$4}' > out_sp1_sp2.4960.list
python $binpath/filterT1.py out_sp1_sp2.4960.list|grep -v ^$ >out_sp1_sp2.4960.filter.list 

outp2=$nowdir/2.wholetree 
mkdir -p $outp2
cd $outp2
ln -s $inoutp 
cat $outp1/out_sp1_sp2.4960.filter.list  |while read out sp1 sp2  ; do python $binpath/StatQuible.py inout $binpath/$phygeny  $out $sp1 $sp2 ;done
ls *.xls >xls.list
python $binpath/StatQuible_filter.py xls.list 

outp3=$nowdir/3.draw
mkdir -p $outp3
cd $outp3
ln -s $outp2/allstat.xls 
cut -f2  allstat.xls|awk -F '_'  'NR>1{print $1}'|sort|uniq > outgroup.txt
mkdir plot 
cd plot
python $binpath/addType.py ../allstat.xls ../outgroup.txt LACAGI 
cd ..
ls plot/*.txt|grep -v LACAGI.txt> a.list 
python $binpath/GenerateMix.py a.list ILS_introng.txt species.txt
Rscript $binpath/plot.r
