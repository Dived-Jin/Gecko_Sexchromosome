#/bin/bash
#######bin path
scriptp=`dirname "$(realpath $0)"`
binpath="$scriptp/bin"
NGenomeSyn="" #download form https://github.com/hewm2008/NGenomeSyn.git
########rawinput 
nodehubls=$1
Conservedseg=$2

######
mkdir plot
cd plot 
ln -s $Conservedseg Conserved.Segments
cat $nodehubls |while read line filpath linkname
do
    ln -s $filpath $linkname
done

##########
for i in nod*.gen.PQTREE;do name=`echo $i|awk -F "." '{print $1}'`; python $binpath/ancestral_karyotype_reorder.py ancestor_colorByAnc/$name.conv.len ${i}_k_PQTREE_HEUR.order;done
ls *.PQTREE | while read i
do
    perl $binpath/ancestral_seg_order.pl Conserved.Segments $i CORSAR-CORCIL-PYGNIG-NEPLEV-EUBMAC-COLBRE-SPHMIN-ARIPRA-THERAP-PHYWIR-TARMAU-PHELAT-PARSTU-CHRMAR-GEHMUT-HEMMAB-HEMFRE-HETBIN-GEKJAP-LACAGI-THAELE > $i.seg_tab
    perl $binpath/gene_tab.pos_convert.v1.pl $i.seg_tab 19 5000 > $i.seg_tab.Hsap.conv
done

perl $binpath/seg2pos.pl Conserved.Segments > Conserved.Segments.pos
awk '{print $2"\tnode1\tchr"$1"\t"$4"\t"$5}' node1.gen.PQTREE.seg_tab.Hsap.conv >tmp
perl $binpath/AddColumn.v2.pl node1.gen.PQTREE.seg_tab tmp 2 >ancestor.addnode
for i in {2..18}
do
    echo $i
    awk '{print $2"\tnode'$i'\tchr"$1"\t"$4"\t"$5}' node${i}.gen.PQTREE.seg_tab.Hsap.conv >tmp
    perl $binpath/AddColumn.v2.pl ancestor.addnode tmp 2 >ancestor.addnode.tmp
    mv ancestor.addnode.tmp ancestor.addnode
done

##################
mkdir ancestor_colorByAnc 
cd ancestor_colorByAnc 
for f in ../node*.gen.PQTREE.seg_tab.Hsap.conv ;do n=`basename $f |awk -F "." '{print $1}'`;ln -s $f $n.conv ;done
ls node*.conv |while read lin
do
    n=`echo $line |awk -F "." '{print $1}'`
    perl $binpath/conv2len.pl $line > $n.conv.len
    awk '{print $1"\t"$1"\t1\t"$2"\t1\t"$2}' $n.conv.len > $n.conv.info
done
for i in node{1..18}
do
    perl $binpath/draw_extant.v1.3.pl $scriptp/example/node1.color.config ancestor.addnode $i.conv.info $i.conv.len node1 > node1.PQTREE.seg_tab.$i.svg
done
cd .. 
#######################
mkdir plotlinear 
cd plotlinear
mkdir rawfile1
python $binpath/compared.py >ancestor.addnodes
python $binpath/region.py
$NGenomeSyn/NGenomeSyn -InConf in1.conf -OutPut OUT1 
