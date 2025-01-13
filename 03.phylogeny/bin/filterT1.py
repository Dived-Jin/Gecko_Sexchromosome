import sys,os
f1 = open(sys.argv[1],'r')
unsed = []
klsm = []
for line in f1:
	iterms = line.strip().split()
	kls = list(sorted(iterms))
	js = '_'.join(kls)
	if js not in unsed:
		unsed.append(js)
		klsm.append(line)

print('%s'%("".join(klsm)))
