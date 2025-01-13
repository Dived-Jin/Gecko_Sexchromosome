mkdir s1.baseml
cd s1.baseml
baseml4.5 baseml.ctl
grep alpha baseml.mlb |tail -1 |awk '{print "alpha = "$NF}' >para.txt
n=`awk '{print NR"\t"$0}' baseml.mlb |grep "Substitution rate" |awk '{print $1+1}'`
awk '{if(NR=="'$n'")print "substitution rate = "$1}' baseml.mlb >>para.txt
cd ..

mkdir s2.gHmatrix
cd s2.gHmatrix
mcmctree4.5 mcmctree.ctl
ln -s rst2 out.BV 
cd .. 

mkdir s3.finetune
cd s3.finetune
ln -s ../s2.gHmatrix/out.BV in.BV
cd ..

mkdir s4.mcmctree
