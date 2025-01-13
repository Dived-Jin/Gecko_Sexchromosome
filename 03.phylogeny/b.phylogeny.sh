#/bin/bash
#######bin path
scriptp=`dirname "$(realpath $0)"`
binpath="../$scriptp/bin"
IQtreepath="" #download from https://github.com/Cibiv/IQ-TREE.git.
Astralpath="" #download from https://github.com/chaoszhang/ASTER.git.
Raxmlpath="" #download from https://github.com/amkozlov/raxml-ng.git.

######### Raw path

Seedlsf="Seed.list"
AlignmentPath=""

###
cat $scriptp/example/species.txt >speciesA.txt

#####Get Sequence 
mkdir IQtree
cd IQtree
python $binpath/GetSequence.py $AlignmentPath/seq/genes $Seedlsf speciesA.txt Alignment
ls Alignment/A*/Align*/*.fa >pathfile1.txt
Nowdir=`pwd`
cat pathfile1.txt |while read line
do
    Filepath=$Nowdir/$line
    echo "$IQtreepath/iqtree2 -m MFP -s $Filepath -b 100 -nt AUTO -safe -redo --threads-max 3 -o THAELE,LACAGI"
done >Iqtree_command1.sh 
sh Iqtree_command1.sh
cd ../

########merge Tree 
mkdir Astral
cd Astral
cat pathfile1.txt |while read line;do if [ -f ${line}.treefile ];then cat ${line}.treefile && echo -e "\t$line";fi;done >tree.list.tree
$Astralpath/astral-hybrid -x 100 -n 0 tree.list.tree >1k.windows.filter0_100.log 
ln -s 1k.windows.filter0_100.log Gekko_24_finaltopology.nwk
cd ../

#####branch length
mkdir branch_length
cd branch_length
n=0
for mode in {"JC","JC+G","GTR","GTR+G+FC",'GTR+G+FO',"GTR+R4+FO"}
do
    n=`expr $n + 1`
    prefix="E${n}"
    $Raxmlpath/raxml-ng --evaluate --msa Mergeall_ungap.fa --threads 10 --model $mode --tree Gekko_24_finaltopology.nwk --prefix $prefix
done 
$Raxmlpath/raxml-ng --evaluate --msa Mergeall_ungap.fa --threads 10 --model GTR+G --tree Gekko_24_finaltopology.nwk --prefix Mcmctree_para
cd ..
