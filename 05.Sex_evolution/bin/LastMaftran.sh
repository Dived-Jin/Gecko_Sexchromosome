Kentkit="" #Path of kent tools 
bintools="../../02.AlignmentLAST/bin"
lastzpath="" #path of lastZ
outdir=$1
tarfile=$2
qurfile=$3
maffile=$4
types=$5
outshell=$outdir/Transmaf${types}.sh 
echo "cd $outdir" >$outshell
echo "mkdir Transf${types}" >>$outshell
echo "cd Transf${types}" >>$outshell
echo "ln -s $tarfile"  >>$outshell
echo "ln -s $qurfile"  >>$outshell
echo "$Kentkit/faToTwoBit $tarfile target.2bit"  >>$outshell
echo "$Kentkit/faToTwoBit $qurfile query.2bit"  >>$outshell
echo "$Kentkit/faSize $tarfile -detailed >target.sizes" >>$outshell
echo "$Kentkit/faSize $qurfile -detailed >query.sizes" >>$outshell
echo "echo '##maf version=1 scoring=LAST' >out.addTile.maf"  >>$outshell
echo "python $bintools/Modifymaf.py $maffile out.addTile.maf"  >>$outshell
echo "$Kentkit/mafToAxt out.addTile.maf target query out.addTile.axt" >>$outshell
echo "sed 's/target\.//' out.addTile.axt |sed 's/query\\.//' >out.rmTile.axt" >>$outshell
echo "$Kentkit/axtChain -minScore=5000 -linearGap=/hwfssz2/zebra_bgiseq500/yjy_data/Admin/Users/jinjiazheng/Script/Zhoubin/pipeline/lastz/loose out.rmTile.axt target.2bit query.2bit out.rmTile.chain" >>$outshell
echo "$Kentkit/chainPreNet out.rmTile.chain target.sizes query.sizes out.rmTile.sorted.chain" >>$outshell
echo "$Kentkit/chainNet out.rmTile.sorted.chain target.sizes query.sizes ./tmp  query.net"  >>$outshell
echo "$Kentkit/netSyntenic ./tmp target.net" >>$outshell
echo "grep -E '(^net|type top)' target.net | perl $bintools/net2aln.pl - > target.net.filt.aln"  >>$outshell
echo "$Kentkit/netToAxt target.net out.rmTile.sorted.chain target.2bit query.2bit out.Net2.chain"  >>$outshell
echo "$Kentkit/axtSort out.Net2.chain out.Net2.sorted.chain"  >>$outshell 
echo "$Kentkit/axtToMaf -tPrefix=target -qPrefix=query out.Net2.sorted.chain target.sizes query.sizes out.Net2maf.maf"  >>$outshell
echo "sed 's/target/target\./' out.Net2maf.maf |sed 's/query/query\./' >out.Net2maf.add.maf"  >>$outshell
echo "perl $bintools/maf2pos.v2.1.pl out.Net2maf.add.maf . target-query"  >>$outshell
echo "paste target.maf.pos query.maf.pos | cut -f2-5,7-10 > out.Net2maf.add.maf.aln" >>$outshell
