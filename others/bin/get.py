import sys,os,pysam
inputls = sys.argv[1:]
lsf = open(inputls[0],'r')
inputf = pysam.FastaFile(inputls[1])
outf = open(inputls[2],'w')
for i in lsf:
	iterms = i.strip().split()
	id1,id2 = iterms
	seq = inputf.fetch(id1)
	outf.write(">%s\n%s\n"%(id2,seq))
lsf.close()
outf.close()
