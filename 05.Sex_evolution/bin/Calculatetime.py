import sys,os 
import sys,re
from scipy import stats
import numpy as np
import math
f1 = open(sys.argv[1],'r')
splittime = float(sys.argv[2])
aphy = float(sys.argv[3])
sexty = sys.argv[4]
#XY=m2*(3*@+3)/(4+2*@)  
#ZW=m2*(3*@+3)/(2+4*@)
tile = f1.readline().strip().split()
n = 0
divls = []
for line in f1:
	n += 1
	if n >1000:
		continue
	iterms = line.strip().split()
	localdict = dict(zip(tile,[float(i) for i in iterms]))
	m1 = localdict['m1']
	m2 = localdict['m2']
	m3 = localdict.get('m3',0)
	if sexty == "XY":
		A = (m2 * (3 * aphy + 3))/(4 + 2 * aphy)
	else:
		A = (m2 * (3 * aphy + 3))/(2 + 4 * aphy)
	percent = (A + m3)/(A + m3 + m1)
	divertime = round(splittime * percent,4)
	divls.append(divertime)
f1.close()

timeksort = list(sorted(divls))
indxk=int(len(timeksort)*0.025)
lower = timeksort[indxk-1]
upper = timeksort[-indxk]
print('%.5f ~ %.5f'%(lower,upper))
