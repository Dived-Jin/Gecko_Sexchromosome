#/bin/bash
#######bin path
scriptp=`dirname "$(realpath $0)"`
binpath="$scriptp/bin"
LastPath=""
Kentoolspath=""
LastZpath=""

############# raw input fasta
targetspecies=$1
queryspecies=$2

############# reference build index
$LastPath/lastdb -P20 -uNEAR -R01 -c ${targetspecies}_index $targetspecies

############ alignment step
$LastPath/last-train  -P20 --revsym --matsym --gapsym -E0.05 -C2 ${targetspecies}_index $queryspecies >${queryspecies}.train
$LastPath/lastal -P20 -m50 -E0.05 -C2 -p ${queryspecies}.train ${targetspecies}_index $queryspecies >many-to-one.maf
$LastPath/last-split -r many-to-one.maf | $LastPath/last-postmask > out.maf 

##########deal with alignment maf
mkdir Transf
cd Transf
$Kentoolspath/faToTwoBit ../$targetspecies >target.2bit
$Kentoolspath/faToTwoBit ../$queryspecies >query.2bit
$Kentoolspath/faSize ../$targetspecies -detailed >target.sizes
$Kentoolspath/faSize ../$queryspecies -detailed >query.sizes
echo '##maf version=1 scoring=LAST' >out.addTile.maf
python $binpath/Modifymaf.py ../out.maf out.addTile.maf
$Kentoolspath/mafToAxt out.addTile.maf target query out.addTile.axt
sed 's/target\.//' out.addTile.axt |sed 's/query\.//' >out.rmTile.axt
$Kentoolspath/axtChain -minScore=5000 -linearGap=$LastZpath/oose out.rmTile.axt target.2bit query.2bit out.rmTile.chain
$Kentoolspath/chainPreNet out.rmTile.chain target.sizes query.sizes out.rmTile.sorted.chain
$Kentoolspath/chainNet out.rmTile.sorted.chain target.sizes query.sizes ./tmp  query.net
$Kentoolspath/netSyntenic ./tmp target.net
grep -E '(^net|type top)' target.net | perl $binpath/net2aln.pl - > target.net.filt.aln
$Kentoolspath/netToAxt target.net out.rmTile.sorted.chain target.2bit query.2bit out.Net2.chain
$Kentoolspath/axtSort out.Net2.chain out.Net2.sorted.chain
$Kentoolspath/axtToMaf -tPrefix=target -qPrefix=query out.Net2.sorted.chain target.sizes query.sizes out.Net2maf.maf
sed 's/target/target\./' out.Net2maf.maf |sed 's/query/query\./' >out.Net2maf.add.maf
perl $binpath/maf2pos.v2.1.pl out.Net2maf.add.maf . target-query
paste target.maf.pos query.maf.pos | cut -f2-5,7-10 > out.Net2maf.add.maf.aln
