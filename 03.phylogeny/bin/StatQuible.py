#### this script is used to deal quilbal outfile
import sys,os,re  
import math,glob 
import ete3
def checkT1():
    global sp1,sp2,sp3,Atopology
    toplis = [(sp1,sp2,sp3),(sp2,sp1,sp3),(sp3,sp1,sp2)]
    merdict = {}
    for top in toplis:
        lca = "(%s,(%s,%s));"%(top)
        ta = ete3.Tree(lca)
        if Atopology.compare(ta)['rf'] == 0:
            merdict["T1"] = top
        else:
            if "T2" in merdict:
                merdict["T3"] = top
            else:
                merdict["T2"] = top
    print(merdict)
    return merdict

def ReadOut(files):
	Mergedic = {}
	total_tree = 0
	with open(files,'r') as h1:
		h1.readline()
		for line in h1:
			iterms = line.strip().split(',')
			spl = iterms[0].strip().split('_')
			if len(set(spl+[sp1,sp2,sp3])) !=3:
				continue
			total_tree += float(iterms[10])
			if iterms[1] == outgroup["T1"][0]:
				Toplog = "T1"
				or1,or2,or3 = outgroup["T1"]
			elif iterms[1] == outgroup["T2"][0]:
				Toplog = "T2"
				or1,or2,or3 = outgroup["T2"]
			else:
				Toplog = "T3"
				or1,or2,or3 = outgroup["T3"]
			struc = "(%s,(%s,%s))"%(or1,or2,or3)
			if float(iterms[8]) -float(iterms[9]) < -10:
				Mergedic[Toplog] = {'Introgression':float(iterms[5])*float(iterms[10]),'ILS':float(iterms[4])*float(iterms[10]),"C2":float(iterms[3]),"Topo":struc}
			else:
				Mergedic[Toplog] = {'Introgression':0,'ILS':float(iterms[10]),"C2":float(iterms[3]),"Topo":struc}
	for k in ["T1","T2","T3"]:
		for k1 in ['Introgression','ILS']:
			Mergedic[k][k1] = Mergedic[k][k1]/float(total_tree)
	return Mergedic

def main():
    global sp1,sp2,sp3,outgroup,Atopology
    rawpath,treefile,sp1,sp2,sp3 = sys.argv[1:]
    with open(treefile,'r') as h1:
        Trestr = h1.readline().strip()
        Atopology = ete3.Tree(Trestr)
        Atopology.prune([sp1,sp2,sp3])
    h1.close()
    print(Atopology)
    outgroup = checkT1()
    outfile = open("%s_%s_%s.xls"%(sp1,sp2,sp3),'w')
    outfile.write('Triplet\tIndex\tTopology\tType\tratio\ttimes\tTopo_struct\n')
    OUTfileLs = glob.glob(os.path.join(rawpath,'Out.csv*'))	
    for Outfil in OUTfileLs:
        idx = Outfil.strip().split('.')[-1]
        indx = "Random_%s"%(idx)
        oudict = ReadOut(Outfil)
        for Topy in ["T1","T2","T3"]:
            Thedic = oudict[Topy]
            writeL1 = ["_".join([sp1,sp2,sp3]),indx,Topy,"ILS",str(Thedic['ILS']),str(Thedic['C2']),Thedic['Topo']]
            writeL2 = ["_".join([sp1,sp2,sp3]),indx,Topy,"Introgression",str(Thedic['Introgression']),str(Thedic['C2']),Thedic['Topo']]
            outfile.write('%s\n%s\n'%('\t'.join(writeL1),'\t'.join(writeL2)))
    outfile.close()
if __name__ == "__main__":
	main()