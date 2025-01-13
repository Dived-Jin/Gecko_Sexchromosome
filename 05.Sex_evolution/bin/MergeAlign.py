import sys,os,re
from collections import Counter
def Getsexty():
	spf = "/hwfssz2/zebra_bgiseq500/yjy_data/Admin/Users/jinjiazheng/Gecko_Sexchromosome/species.txt"
	h1 = open(spf,'r')
	redict = {}
	for l1 in h1:
		ls = l1.strip().split()
		key = ls[1]
		sxe = ls[0].split('.')[-1]
		redict[key] = list(sxe)
	h1.close()
	return redict 

f1 = open(sys.argv[1],'r')
f2 = open(sys.argv[3],'w')
ftree = open(sys.argv[2],'r')
treek = ftree.readline().strip()
Treenamels = [i[::-1] for i in re.findall(r'((\w{6})_\w)',treek)]
TreenameDict = dict(Treenamels)
dics = {}
for line in f1:
	if line.startswith('s'):
		iterms = line.strip().split()
		spn = iterms[1].split('.')[0]
		if spn not in dics:
			dics[spn] = ""
		dics[spn] += iterms[-1]
f1.close()
spnls = [re.split('_',i)[0] for i in dics]
sedict = Getsexty()
slk1 = dict(Counter(spnls))
slk1_sort = list(sorted(slk1.items(), key = lambda x: x[1], reverse = True))
number = len(spnls)
length = len(dics[spnls[0]])
f2.write('%d %d\n'%(number,length))
for subl in slk1_sort:
	spnk,n = subl
	if n == 1:
		IDs = TreenameDict[spnk]
		f2.write('%s  %s\n'%(IDs,dics[spnk]))
	else:
		sexls = sedict[spnk]
		for sexk in sexls:
			wspn = "%s_%s"%(spnk,sexk)
			if sexk in ['Z','X']:
				spnk1 = spnk
			else:
				spnk1 = "%s_WY"%(spnk)
			f2.write('%s  %s\n'%(wspn,dics[spnk1]))
f2.close()
