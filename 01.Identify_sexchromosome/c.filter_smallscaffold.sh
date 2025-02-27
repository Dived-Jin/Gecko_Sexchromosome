#/bin/bash

#######bin path
scriptp=`dirname "$(realpath $0)"`
binpath="$scriptp/bin"

############# Raw input
sexbed=$1 # identify by depth or Fst methods nad the length larger than 10Mb 
Autosomebed=$2 # the length larger than 10Mb 
smallscaffold=$3 
HiCstrengthMatrix=$4 #generated by ../others/HiC_strength_calculate.sh 
HiCstrengthbed=$5 #generated by ../others/HiC_strength_calculate.sh
outfile=$6 

#############run
python $binpath/GetStrengthVale_byhicpro_matrix.py $sexbed $Autosomebed $smallscaffold $HiCstrengthMatrix $HiCstrengthbed $outfile
