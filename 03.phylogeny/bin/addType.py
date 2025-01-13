import sys,os,re
def SubDeal(inputls):
	line1,line2 = inputls
	li1ls = line1.strip().split()
	li2ls = line2.strip().split()
	mark = "raw"
	ILSv = float(li1ls[4])
	INTv = float(li2ls[4])
	TopILS = li1ls[-1]
	TopINT = li2ls[-1]
	ILSvk = 0
	INTvk = 0
	if ILSv > 0.005:
		ILSvk = ILSv
		if INTv > 0.005:
			mark = "%s%sILS%sINTR"%(li1ls[-1],ILSv,INTv)
			INTvk = INTv
		else:
			mark = "%s%sILS"%(li1ls[-1],ILSv)
	else:
		if (INTv > 0.005):
			mark = "%s%sINTR"%(li2ls[-1],INTv)
			INTvk = INTv
	return mark,ILSvk,INTvk,re.findall(r'\w+',li1ls[-1])

def addict(mark,ILSvkT,INTvkT,out,sp):
	if mark == "raw":
		return 0
	if Dichas[out][sp] == "NONE":
		Dichas[out][sp] = mark
	else:
		Dichas[out][sp] += ",%s"%(mark)
	if Dichas[sp][out] == "NONE":
		Dichas[sp][out] = mark
	else:
		Dichas[sp][out] += ",%s"%(mark)	
	diclis[out][sp]['num'] += 1
	diclis[out][sp]['val'] += ILSvkT
	dicintr[out][sp]['num'] += 1
	dicintr[out][sp]['val'] += INTvkT
	diclis[sp][out]['num'] += 1
	diclis[sp][out]['val'] += ILSvkT
	dicintr[sp][out]['num'] += 1
	dicintr[sp][out]['val'] += INTvkT
	

def main():
	global Dichas,dictchek,diclis,dicintr
	inputf,speciesfile,Reference = sys.argv[1:]
	with open(speciesfile,'r') as h1:
		Spnls = [i.strip() for i in h1]
	h1.close()
	Dichas,dictchek,diclis,dicintr = {},{},{},{}
	num = len(Spnls)
	for i in range(num):
		spn = Spnls[i]
		Dichas[spn] = {}
		dictchek[spn] = {}
		diclis[spn] = {}
		dicintr[spn] = {}
		for i1 in range(num):
			spn1 = Spnls[i1]
			dictchek[spn][spn1] = 0
			diclis[spn][spn1] = {'val':0,'num':0}
			dicintr[spn][spn1] = {'val':0,'num':0}
			if spn == spn1:
				Dichas[spn][spn1] = "OUT"
			else:
				Dichas[spn][spn1] = "NONE"
	with open(inputf,'r') as h2:
		h2.readline()
		while True:
			ls = [[h2.readline() for i in range(2)]for i1 in range(3)]
			if not(ls[0][0]):
				break
			T1ls,T2ls,T3ls = ls 
			out,sp1,sp2 = re.findall(r'\w+',T1ls[0].strip().split()[-1])
			markT2,ILSvkT2,INTvkT2,T2spls = SubDeal(T2ls)
			markT3,ILSvkT3,INTvkT3,T3spls = SubDeal(T3ls)
			SP0 = out
			if sp1 == T2spls[0]:
				SP1 = sp2
				SP2 = sp1
			else:
				SP1 = sp1
				SP2 = sp2
			dictchek[out][SP1] += 0
			dictchek[out][SP2] += 0
			addict(markT2,ILSvkT2,INTvkT2,out,SP1)
			addict(markT3,ILSvkT3,INTvkT3,out,SP2)
	h2.close()
	for i1 in range(num):
		spn1 = Spnls[i1]
		outf = open('%s.txt'%(spn1),'w')
		outf.write("Id\tType\tILSratio|INTRratio\tILSnum|INTRnum\tToponumber\tnote\n")
		for i2 in range(num):
			spn2 = Spnls[i2]
			if spn2 == Reference:
				continue
			Mars = Dichas[spn1][spn2]
			rils = 0
			rintr = 0
			if Mars == "NONE":
				types = "NONE"	
			elif Mars == "OUT":
				types = "REF"
			elif "ILS" in Mars and "INTR"  in Mars:
				types = "BOTH"
			elif "ILS" in Mars:
				types = "ILS"
			else:
				types = "INTR"
			if types in ["ILS",'BOTH']:
				print(diclis[spn1][spn2]['num'])
				rils = round(float(diclis[spn1][spn2]['val']*100)/diclis[spn1][spn2]['num'],2)
			if types in ["BOTH","ILS"]:
				print(dicintr[spn1][spn2]['num'])
				rintr = round(float(dicintr[spn1][spn2]['val']*100)/dicintr[spn1][spn2]['num'],2)	
			wirtels = [spn2,types,"%s|%s"%(rils,rintr),"%s|%s"%(diclis[spn1][spn2]['num'],dicintr[spn1][spn2]['num']),str(dictchek[spn1][spn2]),str(Dichas[spn1][spn2])]
			outf.write('%s\n'%('\t'.join(wirtels)))			
		outf.close()
if __name__ == "__main__":
	main()
