import sys,os
import numpy as np
from scipy import stats
import ete3 
import json
########################################
jsonfile = open(sys.argv[1],'r')
JsonDict = json.load(jsonfile)
jsonfile.close()
#######################################
rawinputfile = open(sys.argv[2],'r')
#rawls = rawinputfile.readlines()
#rawinputfile.close()
TreeLs = []
#for i in range(len(rawls)):
#	Markl = rawls[i]
#	if Markl.startswith('tree length ='):
#		TreeLs.append(rawls[i+4])
#		print(rawls[i+4])
addtree = False
for line in rawinputfile:
	if line.startswith('tree length ='):
		addtree = 1
		continue
	if addtree:
		addtree += 1
	else:
		continue
	if addtree == 5:
		TreeLs.append(line)
		addtree = False
rawinputfile.close()
##########################################
markerspn = sys.argv[3]
Markdict = JsonDict[markerspn]
Comdict = {}
for subtree in TreeLs:
	nodeid = {}
	tree = ete3.Tree(subtree)
	for nodeN,[G1,G2] in Markdict["NodeN"].items():
		ids = tree.get_common_ancestor(G1,G2)
		nodeid[nodeN] = ids
	for km,[n1,n2] in Markdict['Length'].items():
		if n1 in nodeid and n2 in nodeid:
			lens = tree.get_distance(nodeid[n1],nodeid[n2])
		elif n1 not in nodeid:
			lens = tree.get_distance(n1,nodeid[n2])
		elif n2 not in nodeid:
			lens = tree.get_distance(nodeid[n1],n2)
		else:
			lens = tree.get_distance(n1,n2)
		if km not in Comdict:
			Comdict[km] = []
		Comdict[km].append(float(lens))
##################################################
Outf = open(sys.argv[4],'w')
keys = list(Comdict.keys())
Outf.write('%s\n'%('\t'.join(keys)))
print(Comdict)
for i in range(len(Comdict[keys[0]])):
	writel = [str(Comdict[i1][i]) for i1 in keys]
	Outf.write('%s\n'%('\t'.join(writel)))
Outf.write('\n\n')
for nodes in keys:
	ls = Comdict[nodes]
	#lower,upper = stats.t.interval(0.95,len(ls)-1,loc=np.mean(ls),scale=stats.sem(ls))
	sortls = list(sorted(ls))
	indxk = int(len(sortls)*0.025)
	lower = '{:.2e}'.format(sortls[indxk-1])
	upper = '{:.2e}'.format(sortls[-1])
	Outf.write('%s\t%s~%s\n'%(nodes, lower, upper))
Outf.close()

