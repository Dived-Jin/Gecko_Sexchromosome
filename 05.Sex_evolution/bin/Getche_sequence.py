import sys,os
import pysam
f1 = open(sys.argv[1],'r')
Idls = [i.strip() for i in f1]
f1.close()
Fastf = pysam.FastaFile(sys.argv[2])
outf = open(sys.argv[3],'w')
CONS = sys.argv[4]
Maskn = ['a','t','c','g']
for chrid in Idls:
	seq = Fastf.fetch(chrid)
	for k in Maskn:
		seq = seq.replace(k,'n')
	if CONS == "CORSAR" and chrid == "chrW":
		seq = "n" * 31550000 + seq[31550000:]
	outf.write('>%s\n%s\n'%(chrid,seq))
outf.close()		
