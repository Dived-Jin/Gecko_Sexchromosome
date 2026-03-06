#/bin/bash
#######bin path
scriptp=`dirname "$(realpath $0)"`
binpath="../$scriptp/bin"
##########
Rscript bin/model_fitting.plusYW.r $1 $2

########################################
#usage Rscript $binpath/bin/model_fitting.plusYW.r expression_matrix.format expression_matrix.format.test
