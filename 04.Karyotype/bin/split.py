import sys,os,re
def Readlengths(files):
	redict = {}
	lens = []
	h1 = open(files,'r')
	for line in h1:
		lenlis = line.strip().split()
		k = lenlis[0]
		le = lenlis[-1]
		redict[k] = le 
		lens.append(k)
	h1.close()
	return redict,lens 

f1 = open("ancestor.addnodes",'r')
Colorfile = open("node1.color.config",'r')
Colordict = {}
for line1 in Colorfile:
	k1,k2,k3 = line1.strip().split()
	keys = "chr%s"%(k2) 
	Colordict[keys] = k3 
Colorfile.close()

mark1 = "node1"
mark2 = "CORSAR"
K1 = sys.argv[1]
K2 = sys.argv[2]
outfile = open(sys.argv[3],'w')
inputlenK2file = "rawfile1/%s.len"%(K2)
ouputlenK2file = open("rawfile1/%s.oder.len"%(K2),'w')
K2dict,K2lens = Readlengths(inputlenK2file)
iterms = f1.readline().strip().split("\t")
st1 = iterms.index(K1)
st2 = iterms.index(K2)
st3 = iterms.index(mark1)
st4 = iterms.index(mark2)
outls = iterms[st1+1:st1+4] + iterms[st2+1:st2+4] + ['fill=\"%s\"\tstroke=\"%s\"'%(Colordict[iterms[st3+1]],Colordict[iterms[st3+1]])]
keL1 = iterms[st2+1]
keL2 = iterms[st4+1]
dicmerge1 = {}
#try:
#	dicmerge1[keL1][keL2] = abs(int(iterms[st2+2])-int(iterms[st2+3])) + 1
#except:
#	pass 
for line in f1:
	iterms = line.strip().split('\t')
	outls = iterms[st1+1:st1+4] + iterms[st2+1:st2+4] + ['fill=\"%s\"\tstroke=\"%s\"'%(Colordict[iterms[st3+1]],Colordict[iterms[st3+1]])]
	outfile.write('%s\n'%('\t'.join(outls)))
	keL1 = iterms[st2+1]
	keL2 = iterms[st4+1]
	#if keL1 not in dicmerge1:
	#	dicmerge1[keL1] = {}
	#if keL2 not in dicmerge1[keL1]:
	#	dicmerge1[keL1][keL2] = abs(int(iterms[st2+2])-int(iterms[st2+3])) + 1
	#else:
	#	dicmerge1[keL1][keL2] += abs(int(iterms[st2+2])-int(iterms[st2+3])) + 1
f1.close()
b = "chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chrZ chrWPAR"
blis = b.strip().split()
Wrend = [None] * 20
wn = []
ids = 0
for k in K2lens:
	if k not in dicmerge1:
		wn.append(k)
		continue
	dicLocal = dicmerge1[k]
	sortedL = sorted(dicLocal.items(),key=lambda x:x[1],reverse=True)
	max = sortedL[0][0]
	indexa = blis.index(max)
	if Wrend[indexa] == None:
		Wrend[indexa] = k 
	else:
		km1 = Wrend[indexa]
		Wrend[indexa] = "%s,%s"%(km1,k)
ids = 0
for i in range(20):
	k = Wrend[i]
	if k == None:
		try:
			Wrend[ids] = wn[ids]
			ids += 1
		except:
			continue
outoder = Wrend
for k in wn:
	if k not in Wrend:
		outoder.append(k)

for wrkey in outoder:
	if wrkey == None:
		continue
	for lel in re.split(r',',wrkey):
		lel1 = K2dict[lel]
		ouputlenK2file.write('%s\t1\t%s\n'%(lel,lel1))
ouputlenK2file.close()
