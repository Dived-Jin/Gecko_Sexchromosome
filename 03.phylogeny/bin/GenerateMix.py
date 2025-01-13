import sys,os
def Readout(files):
    dics = {}
    ref = None
    with open(files,'r') as h1:
        h1.readline()
        for line1 in h1:
            iterms = line1.strip().split()
            key = iterms[0]
            if iterms[1] == "REF":
                ref = iterms[0]
            valls = iterms[2].split("|")
            dics[key] = [round(float(valls[0])/100,2),round(float(valls[1])/100,2)]
    h1.close()
    return dics,ref


def main():
    filterlist = open(sys.argv[1],'r')
    outfile = open(sys.argv[2],'w')
    speciesfile = open(sys.argv[3],'r')
    Speciesoder = {}
    n = 0
    for spn in speciesfile:
        n += 1
        spn = spn.strip()
        Speciesoder[spn] = n
    speciesfile.close()
    outfile.write('speciesA\tspeciesB\tratio\tType\n')
    MerDict = {}
    for line in filterlist:
        p = line.strip()
        dim,ref = Readout(p)
        print(dim)
        if ref == None:
            continue
        for k,v in dim.items():
            k1 = "%s_%s"%(ref,k)
            k2 = "%s_%s"%(k,ref)
            if k1 in MerDict or k2 in MerDict:
                continue
            MerDict[k1] = [str(i) for i in v]
    print(Speciesoder)
    for keys,vlis in MerDict.items():
        sp1,sp2 = keys.split("_")
        if Speciesoder[sp1] >Speciesoder[sp2]:
            ILSty = '%s\t%s'%(sp1,sp2)
            INTty = '%s\t%s'%(sp2,sp1)
        else:
            ILSty = '%s\t%s'%(sp2,sp1)
            INTty = '%s\t%s'%(sp1,sp2)
        ILSty = '%s\t%s'%(sp1,sp2) if Speciesoder[sp1] >Speciesoder[sp2] else '%s\t%s'%(sp2,sp1)
        INTty = '%s\t%s'%(sp1,sp2) if Speciesoder[sp1] <Speciesoder[sp2] else '%s\t%s'%(sp2,sp1)
        if sp1 == sp2:
            outfile.write('%s\t0.0\tBOTH\n'%(ILSty))
            continue
        outfile.write('%s\t%s\tILS\n%s\t%s\tIntrongression\n'%(ILSty,vlis[0],INTty,vlis[1]))
    outfile.close()
if __name__ == "__main__":
    main()
