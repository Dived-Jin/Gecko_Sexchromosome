#/bin/bash
#######bin path
scriptp=`dirname "$(realpath $0)"`
binpath="$scriptp/bin"
DESCHRAMBLER="" # download frome https://github.com/jkimlab/DESCHRAMBLER.git
############# Raw input
divergence_tree=""
paremater_file=""
Makefile=""
config=""

##########
mkdir 500kb 
cd 500kb 
ln -s $Makefile
ln -s $paremater_file
ln -s $divergence_tree
perl $DESCHRAMBLER/DESCHRAMBLER.pl params.500K.txt > params.500K.txt.log 2> params.500K.txt.log2
perl $binpath/filter_segments_by_species.pl Gekko.500K/SFs/Conserved.Segments CORSAR-CORCIL-PYGNIG-NEPLEV-EUBMAC-COLBRE-SPHMIN-ARIPRA-THERAP-PHYWIR-TARMAU-PHELAT-PARSTU-CHRMAR-GEHMUT-HEMMAB-HEMFRE-HETBIN-GEKJAP >Conserved.Segments.single
