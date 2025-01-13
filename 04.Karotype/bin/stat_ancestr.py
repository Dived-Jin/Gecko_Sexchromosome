import sys,os
f1 = open(sys.argv[1],'r')
dics = {}
spnls = ["CORSAR","CORCIL","PYGNIG","NEPLEV","EUBMAC","COLBRE","SPHMIN","ARIPRA","THERAP","PHYWIR","TARMAU","PHELAT","PARSTU","CHRMAR","GEHMUT","HEMMAB","HEMFRE","HETBIN","GEKJAP"]
for line in f1:
	iterms = line.strip().split()[2:]
	subiterms = [iterms[i:i+4] for i in range(0,len(iterms),4)]
	for subk in subiterms:
		spn,chrs,start,end = subk
		
