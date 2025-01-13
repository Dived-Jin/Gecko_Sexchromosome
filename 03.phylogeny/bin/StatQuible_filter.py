import sys,os
def main():
	XlsLis = open(sys.argv[1],'r')
	merge_dic = {}
	Number_dic = {}
	Time_dic = {}
	treety_dic = {}
	for line in XlsLis:
		files = line.strip()
		with open(files,'r') as h1:
			h1.readline()
			for line1 in h1:
				iterms = line1.strip().split();print(iterms)
				Key,index,Topology,Type,ratio,times,Topo_struct = iterms
				if Key not in treety_dic:
					treety_dic[Key] = {}
				if Topology not in treety_dic[Key]:
					treety_dic[Key][Topology] = Topo_struct
				try:
					merge_dic[Key][Topology][Type] += float(ratio)
					Number_dic[Key][Topology][Type] += 1
					Time_dic[Key][Topology][Type] += float(times)
				except:
					if Key not in merge_dic:
						merge_dic[Key] = {}
						Number_dic[Key] = {}
						Time_dic[Key] = {}
					if Topology not in merge_dic[Key]:
						merge_dic[Key][Topology] = {}
						Number_dic[Key][Topology] = {}
						Time_dic[Key][Topology] = {}
					merge_dic[Key][Topology][Type] = float(ratio)
					Number_dic[Key][Topology][Type] = 1
					Time_dic[Key][Topology][Type] = float(times)
		h1.close()
	XlsLis.close()
	
	outf = open('allstat.xls','w')
	outf.write("ID\tTriplet\tTopology\tType\tAverage\tTreesNumber\ttimes\ttree\n")
	n = 0
	for KeyN,Kdic in merge_dic.items():
		for topology in ['T1','T2','T3']:
			trees = treety_dic[KeyN][topology]
			for ty in ["ILS",'Introgression']:
				n += 1
				aver2 = round(Kdic[topology][ty]/1200,6)
				time2 = round(Time_dic[KeyN][topology][ty]/1200,6)
				num = aver2*1200*1000
				outf.write('%s\n'%('\t'.join([str(n),KeyN,topology,ty,str(aver2),str(num),str(time2),trees])))
	outf.close()
					
if __name__ == "__main__":
	main()
