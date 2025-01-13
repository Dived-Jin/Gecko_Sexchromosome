import glob,pysam,os
path = glob.glob(os.path.join("seq/ungap",'*.fa'))
dictseq = {}
for fa in path:
    fasta = pysam.Fastafile(fa)
    speciesls = fasta.references
    for spn in speciesls:
        seq = fasta.fetch(spn)
        if spn not in dictseq:
            dictseq[spn] = []
        dictseq[spn].append(seq)
outf = open("Mergeall_ungap.fa",'w')
for spn,seq in dictseq.items():
    outf.write('>%s\n%s\n'%(spn,"".join(seq)))
outf.close()
