### inputArgv
alignf=`realpath $1`
node1=$2
node2=$3
Nowdir=`pwd`

###############
Grimmpath=""
binpath= "" #"/hwfssz2/zebra_bgiseq500/yjy_data/Admin/Users/jinjiazheng/Gecko_Sexchromosome/08.Karotype_v2/c.anges.CORSAR_Divergencev1/500k_modify/plota/plotlinear/grimm/bin"
######
function Creatdir(){
    dirm=$1
    if [ ! -d $dirm ];then 
        mkdir $dirm
    fi
}


#############
#main
outdir="${Nowdir}/${node1}_${node2}"
Creatdir $outdir
runstepshell=${outdir}/work.sh 
echo "cd $outdir " >$runstepshell
node1k=`python $binpath/Grimm_index.py $alignf $node1`
node2k=`python $binpath/Grimm_index.py $alignf $node2`
nodearr1=(${node1k// / })
nodearr2=(${node2k// / })
#echo $node1K
#if [[ $node1 =~ ^node ]];then
#    echo "cut -f3,${nodearr1[0]}-${nodearr1[2]} $alignf >temp1" >>$runstepshell
#    echo "cut -f${nodearr2[0]}-${nodearr2[2]} $alignf >temp2" >>$runstepshell
#else
#    echo "cut -f3,${nodearr2[0]}-${nodearr2[2]} $alignf >temp1" >>$runstepshell
#    echo "cut -f${nodearr1[0]}-${nodearr1[2]} $alignf >temp2" >>$runstepshell
#fi
#echo "paste temp1 temp2 |grep -v \"-\"| awk '{print \$3\"\t\"\$0}' |grep -v HiC_scaffold |grep -v SDR |grep -v WPAR |sed 's/^chr//' | sort -k1,1n -k5,5n | awk '{print \$1\"\t\"\$0}' >${node1}_${node2}.align.txt" >>$runstepshell
#echo "cut -f3,${nodearr1[0]}-${nodearr1[2]},${nodearr2[0]}-${nodearr2[2]} $alignf|awk '{print \$3\"\t\"\$0}'  |sed 's/^chr//' | sort -k1,1n -k5,5n | awk '{print \$1\"\t\"\$0}' >${node1}_${node2}.align.txt" >>$runstepshell

echo "cut -f3,${nodearr1[0]}-${nodearr1[2]} $alignf >temp1" >>$runstepshell
echo "cut -f${nodearr2[0]}-${nodearr2[2]} $alignf >temp2" >>$runstepshell
echo "paste temp1 temp2 |grep -v \"-\"| awk '{print \$3\"\t\"\$0}' |grep -v \"SDR\" |grep -v \"WPAR\" |sed 's/^chr//' | sort -k1,1V -k5,5n | awk '{print \$1\"\t\"\$0}' >${node1}_${node2}.align.txt" >>$runstepshell

echo "cut -f9-11 ${node1}_${node2}.align.txt|sed 's/^chr//'|sort -k1,1V -k2,2n|awk '{print \"chr\"\$0}' | sed 's/chrHiC/HiC/'  >${node2}.block" >>$runstepshell
echo "perl $binpath/index_seg.pl ${node2}.block >${node2}.block.lst 2>${node2}.block.grim" >>$runstepshell
echo "perl $binpath/add_idx.pl ${node2}.block.lst ${node1}_${node2}.align.txt 8 >${node1}_${node2}.align.txt.add" >>$runstepshell
echo "cut -f1,2,3,9- ${node1}_${node2}.align.txt.add >${node1}_${node2}.align.txt.add.cut" >>$runstepshell
echo "perl $binpath/format_anc.link.pl ${node1}_${node2}.align.txt.add.cut 1 >${node1}.block.grim" >>$runstepshell
echo "echo \">${node1}\" >${node1}_${node2}.grim" >>$runstepshell
echo "cat ${node1}.block.grim >>${node1}_${node2}.grim" >>$runstepshell
echo "echo \">${node2}\" >>${node1}_${node2}.grim" >>$runstepshell
echo "cat ${node2}.block.grim >>${node1}_${node2}.grim" >>$runstepshell
echo "$Grimmpath -f ${node1}_${node2}.grim -g1,2 -u >${node1}_${node2}.grim.out" >>$runstepshell
echo "perl $binpath/filter_count.v2.Ther.pl ${node1}_${node2}.align.txt.add.cut ${node1}_${node2}.grim.out >${node1}_${node2}.grim.out.stat 2>${node1}_${node2}.grim.out.erro" >>$runstepshell
