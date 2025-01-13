import sys,os
import re
Marka = sys.argv[1]
inputmaf = open(sys.argv[2],'r')
outmaf = open(sys.argv[3],'w')
dicsa = {}
tile = []
for line in inputmaf:
    if line.startswith('#'):
        continue
    if line.startswith('a'):
        if tile:
            if Marka not in dicsa:
                outmaf.write('%s\n'%(tile))
                for spn,wrls in dicsa.items():
                    outmaf.write('%s\n'%(wrls))
                outmaf.write('\n')
        tile = line.strip()
        dicsa = {}
        continue
    if line.startswith('s'):
        iterms = line.strip().split()
        spn = iterms[1].split('.')[0]
        dicsa[spn] = line.strip()
        continue
inputmaf.close()
if Marka not in dicsa:
    outmaf.write('%s\n'%(tile))
    for spn,wrls in dicsa.items():
        outmaf.write('%s\n'%(wrls))
    outmaf.write('\n')
outmaf.close()
