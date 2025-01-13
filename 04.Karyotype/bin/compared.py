import sys,os
f1 = open("compared.txt",'r')
dics = {}
for line in f1:
	iterms = line.strip().split()
	k,k1 = iterms
	dics[k] = k1
f1.close()
f2 = open("ancestor.addnode",'r')
for line in f2:
	iterms = line.strip().split()
	k = iterms[3]
	if k in dics:
		iterms[3] = dics[k]
	print('%s'%('\t'.join(iterms)))
f2.close()
