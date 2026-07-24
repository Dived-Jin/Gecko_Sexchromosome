import sys,os
f1 = open(sys.argv[1],'r')
f2 = open(sys.argv[2],'r')
f3 = open(sys.argv[3],'w')
Tile = f1.readline()
f3.write('%s'%(Tile))
lis = f1.readlines()
sublis = [lis[i:i+2] for i in range(0,len(lis),2)]
dics = {}
for klis in sublis:
	k1,k2 = klis
	k1 = k1.strip()
	k2 = k2.strip()
	dics[k1] = k2
f1.close()

dic1 = {}
for line in f2:
	k,l = line.strip().split()
	dic1[k] = int(l)
f2.close()
dic1sort = list(sorted(dic1.items(),key=lambda x:x[1],reverse=True))
n = 0
for subs in dic1sort:
	n += 1 	
	k ="#CAR%s"%(subs[0])
	l = dics[k]
	f3.write('#CAR%s\n%s\n'%(n,l))
f3.close()
