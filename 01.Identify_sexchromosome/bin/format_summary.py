#!/usr/bin/env python3

import sys
from read_file import read_file
from collections import defaultdict

if len(sys.argv) != 7:
	sys.exit('python3 %s <merge.5k.cov.ratio> <X|Z_min_cutoff> <X|Z_max_cutoff> <Y|W_cutoff> <faiFile> <ZW|XY>' % (sys.argv[0]))

inFile = sys.argv[1]
xmin = float(sys.argv[2])
xmax = float(sys.argv[3])
ycut = float(sys.argv[4])
faiFile = sys.argv[5]
Sexty = sys.argv[6]

lenDic = defaultdict(lambda: 0)
count = defaultdict(lambda: defaultdict(lambda: 0))
store = defaultdict(list)

if Sexty == "XY":
    Sexlis = ['X', 'Y', 'A']
elif Sexty == "ZW":
    Sexlis = ['Z', 'W', 'A']
else:
    print('Unkown sex type, please check')
    sys.exit()

with open(faiFile) as f:
	for line in f:
		line = line.rstrip()
		tmp = line.split('\t')
		scaf = tmp[0]
		l = int(tmp[2])
		lenDic[scaf] = l

def output(scaf, body, count):
	l = lenDic[scaf]
	header = scaf + '\t' + str(l);print(l)
	for i in Sexlis:
		rate = count[i]/l
		header += '\t%i\t%.4f' % (count[i], rate)
	flag = ''
	Auto = "A"
	het = "Y" if Sexty == "XY" else "W"
	hom = "X" if Sexty == "XY" else "Z"
	if count[hom] > count[het] and count[hom] > count[Auto]:
		flag = hom
	elif count[het] > count[hom] and count[het] > count[Auto]:
		flag = het
	elif count[Auto] > count[hom] and count[Auto] > count[het]:
		flag = Auto
	else:
		flag = 'other'
	print('>' + header + '\t' + flag)
	out = '\n'.join(body)
	print(out)

with read_file(inFile) as f:
	for line in f:
		line = line.rstrip()
		tmp = line.split('\t')
		scaf = tmp[0]
		bg = int(tmp[1])
		ed = int(tmp[2])
		ratio = tmp[11]
		flag = ''
		if ratio != 'NA':
			ratio = float(tmp[11])
			if ratio > xmin and ratio < xmax:
				flag = 'X' if Sexty == "XY" else "Z"
			elif ratio < ycut:
				flag = 'Y' if  Sexty == "XY" else "W"
			else:
				flag = 'A'
		else:
			flag = 'A'
		count[scaf][flag] += ed-bg
		store[scaf].append(line + '\t' + flag)

for scaf in sorted(store.keys()):
	output(scaf, store[scaf], count[scaf])

