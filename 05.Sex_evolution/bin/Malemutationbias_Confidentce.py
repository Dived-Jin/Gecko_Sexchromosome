import sys
import numpy as np 
f1 = open(sys.argv[1],'r')
f1.readline()
mergedic = {}
for line in f1:
    iterms = line.strip().split()
    spn = iterms[0]
    if spn not in mergedic:
        mergedic[spn] = []
    mergedic[spn].append(iterms[1:])
f1.close()

for spn,usedls in mergedic.items():
    n = len(usedls)
    rets = []
    for i in range(1000):
        indexls = list(np.random.choice(list(range(n)),size=n, replace=True))
        locls = [usedls[i2] for i2 in indexls]
        hls = [float(i1[0]) for i1 in locls]
        tlis = [float(i1[1]) for i1 in locls]
        lenls = [float(i1[2]) for i1 in locls]
        Weighth = np.average(hls,weights=lenls)
        Weightt = np.average(tlis,weights=lenls)
        retio = Weighth/Weightt
        rets.append(retio)
    solretio = list(sorted(rets))
    print('%s\t%.4f\t%.4f'%(spn,solretio[49],solretio[949]))  
