import sys,os,time
def readlis(files):
    global ChrLength
    with open(files,'r') as h1:
        head = h1.readline()
        iterms = head.strip().split()
        species = iterms[2:]
        line1 = h1.readline()
        iterms1 = line1.strip().split()
        Star = int(iterms1[1])
        redic = dict(zip(species,iterms1[2:]))
        if Star != 1:
            lengtha = Star - 1
            adda = "-" * lengtha
            for i in species:
                redic[i] = [adda,redic[i]]
        else:
            for i in species:
                redic[i] = [redic[i]]
        n = 0
        timea = time.time()
        for line in h1:
            n += 1
            iterms2 = line.strip().split()
            basels = iterms2[2:]
            Nowsit = int(iterms2[1])
            leng = Nowsit - Star
            locdic = dict(zip(species,basels))
            if leng != 1:
                adda = "-" * (leng-1)
                for i in species:
                    locdic[i] = adda + locdic[i]
            Star = Nowsit
            for i in species:
                redic[i].append(locdic[i])
            if n % 1000000 == 0:
                timeb = time.time()
                used = round(float(timeb-timea)/60,2)
                print('%s finished\t %s'%(n,used))
        if Star != int(ChrLength):
            num = int(ChrLength) - Star
            adda = "-" * num
            for i in species:
                redic[i].append(adda)
    h1.close()
    Mergedic = {}
    for spn in species:  
        Mergedic[spn] = "".join(redic[spn])
    return Mergedic,species

def main():
    global ChrLength
    gfffile,maflis,ChrLength = sys.argv[1:]
    MafDic,speciesls= readlis(maflis)
    if os.path.exists('genes') == False:
        os.system('mkdir genes')
    with open(gfffile,'r') as h2:
        for line in h2:
            key = line.strip().split()[0]
            keyls = key.split('_')
            star = int(keyls[-2]) - 1
            end = int(keyls[-1])
            outf = "genes/%s.fa"%(key)
            with open(outf,'w') as h3:
                for spn in speciesls:
                    h3.write('>%s\n%s\n'%(spn,MafDic[spn][star:end]))
            h3.close()

if __name__ == "__main__":
    main()
            
