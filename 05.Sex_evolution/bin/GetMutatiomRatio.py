import sys,os,re,glob
from ete3 import Tree
import numpy as np 
def ReadCodeml(files):
	h1 = open(files,'r')
	ls = [i.strip() for i in h1]
	h1.close()
	tree_index = False
	lengths = False
	for ints in range(len(ls)):
		if ls[ints].startswith('tree length ='):
			tree_index = ls[ints+4]
			continue
		if ls[ints].startswith('After deleting gaps'):
			lengths = ls[ints].strip().split()[-2]
			continue
	if tree_index == False:
		return False
	DSlis = re.findall(r'(\w{6})_(\w):\s*(\d+\.*\d+)',tree_index)
	if bool(DSlis) == False:
		return False
	dics1 = {}
	for sub in DSlis:
		if sub[1] == "A":
			continue
		spn,sex,ds = sub
		if spn not in dics1:
			dics1[spn] = {}
		dics1[spn][sex] = ds
	redic = {}
	if dics1:
		trees = Tree(tree_index)
		for spn,sudic in dics1.items():
			if len(sudic) != 2:
				continue
			sex1,sex2 = list(sudic.keys())
			sexk1 = "%s_%s"%(spn,sex1)
			sexk2 = "%s_%s"%(spn,sex2)
			sex1ds = trees.get_distance(trees.get_common_ancestor(sexk1,sexk2),sexk1)
			sex2ds = trees.get_distance(trees.get_common_ancestor(sexk1,sexk2),sexk2)
			redic[spn] = {sex1:str(round(sex1ds,6)),sex2:str(round(sex2ds,6))}
	if redic:
		if lengths == False:
			lengths = ls[0].strip().split()[-1]
		return [redic,lengths]
	else:
		return False
def main():
	inputdir,outf = sys.argv[1:]
	Dsfilels = glob.glob(os.path.join(inputdir,"*/S*/A*/","mlb"))
	outs = open(outf,'w')
	outs.write('speciesN\tX_Z\tY_W\tlength\n')
	numdict = {}
	for Dsf in Dsfilels:
		rels = ReadCodeml(Dsf)
		if bool(rels) == False:
			continue
		dics,Lens = rels
		for spn,vdic in dics.items():
			if len(vdic) != 2:
				continue
			wril = [spn]
			if spn not in numdict:
				numdict[spn] = [[],[],[],0]
			numdict[spn][-1] += 1
			if "Z" in vdic:
				h,t = [vdic['Z'],vdic['W']]
			else:
				h,t = [vdic["X"],vdic["Y"]]
			wril += [h,t,Lens]
			numdict[spn][0].append(h)
			numdict[spn][1].append(t)
			numdict[spn][2].append(Lens)
			outs.write('%s\n'%('\t'.join(wril)))
	outs.close()
	for spn,parn in numdict.items():
		hls,tlis,lenls,ns = parn
		hls = list(map(lambda x : float(x), hls))
		tlis = list(map(lambda x : float(x), tlis))
		lenls = list(map(lambda x : float(x), lenls))
		Weighth = np.average(hls,weights=lenls)
		Weightt = np.average(tlis,weights=lenls)
		print('%s\t%s\t%s\t%s'%(spn,Weighth,Weightt,ns))

if __name__ == "__main__":
	main()
			
				
