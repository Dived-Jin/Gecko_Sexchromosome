#/bin/bash
#######bin path
scriptp=`dirname "$(realpath $0)"`
binpath="../$scriptp/bin"

############ Raw input 
mafilep = $1
ref = $2
merge_step = $3

###########step1 add snpname
mkdir addspn_maf
cat $mafilep |while read fulln spn maffile 
do
    cat $maffile| awk '{gsub(/target/,"$ref");gsub(/query/,"'$spn'");print}' >addspn_maf/${spn}_${ref}.maf
    python $scriptp/Splitmaf_bychr.py addspn_maf/${spn}_${ref}.maf addspn_maf/${spn}_${ref} $ref
done

######### merge  maf 
cat merge_step | while read maf1path maf2path outmaf outsh
do
    python $binpath/MergeMaf.py $maf1 $maf2 $ref $outmaf $outsh
    sh $outsh
done 
