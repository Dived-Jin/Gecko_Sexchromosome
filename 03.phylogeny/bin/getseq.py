import sys,re
import random
def CheckVal(n):
    global UnvalueLs,UsedLs,InputLs
    PL = list(set(InputLs).difference(set(UnvalueLs+UsedLs)))
    if len(PL) >0:
        try:
            ramdomeLs = random.sample(PL,n)
        except:
                ramdomeLs = PL
        for subk in ramdomeLs:
                iterms = dicsed[subk]
                k,s,e = iterms
                if k in SeedDict:
                    lisa = SeedDict[k]
                    adm = True
                    for sl in lisa:
                        s1,e1,tree = sl
                        if abs(e1-s) < 20000:
                            adm = False
                            break 
                    if adm:
                        SeedDict[k].append([s,e,subk])
                        UsedLs.append(subk)
                    else:
                        UnvalueLs.append(subk)
                else:
                    SeedDict[k] = [[s,e,subk]]
                    UsedLs.append(subk)
        return len(UsedLs)
    else:
        return n

def Readtree(files):
    redict = {}
    with open(files,'r') as h1:
        for line in h1:
            iterms = line.strip().split()
            tree = iterms[0]
            key = "/".join(iterms[-1].split('/')[1:3])
            redict[key] = tree
    h1.close()
    return redict

global InputLs,SeedDict,UnvalueLs,UsedLs,dicsed,Treedic
Seedf = open(sys.argv[1],'r')
inputf1 = sys.argv[2]
dicsed = {}
allLS = [i.strip() for i in Seedf.readlines()]
Seedf.close()
allLS_split = [allLS[i:i+500] for i in range(0,len(allLS),500)]
n = 0
for Subals in allLS_split:
    n += 1
    n0 = 0
    for line in Subals:
        n0 += 1
        Rekey = "A%s/Align%s"%(n,n0)
        iterms = line.strip().split("_")
        chrk = "_".join(iterms[:-2])
        star = int(iterms[-2])
        end = int(iterms[-1])
        dicsed[Rekey] = [chrk,star,end]

Treedic = Readtree(inputf1)
InputLs = list(Treedic.keys())
SeedDict = {}
UnvalueLs,UsedLs = [],[]
rawn = int(sys.argv[3])
lena = 0
while True:
    sen = rawn - lena
    if sen == 0:
        break
    lena = CheckVal(sen)

outa1 = open(sys.argv[4],'w')
outa2 = open(sys.argv[5],'w')
for chrind,subls in SeedDict.items():
    for subls1 in subls:
        s,e,trekey = subls1
        outa1.write('%s\n'%(Treedic[trekey]))
        outa2.write('%s\t%s\t%s\n'%(chrind,s,e))
outa1.close()
outa2.close()
