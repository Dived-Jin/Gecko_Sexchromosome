#/bin/bash
#######bin path
scriptp=`dirname "$(realpath $0)"`
binpath="$scriptp/bin"
anges="" # download frome https://github.com/cchauve/ANGeS.git
############# Raw input
nodeid=""
#########
mkdir anges
cd anges
cat 
cat ../$nodeid |while read line
do
    python $anges/anges_CAR.py $line 1>$line.log 2>$line.log2
done

