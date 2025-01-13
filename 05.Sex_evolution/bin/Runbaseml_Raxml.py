import sys,os
import re
import io
from Bio import AlignIO
Allspnls = "CORSAR CORCIL PYGNIG NEPLEV EUBMAC COLBRE SPHMIN ARIPRA THERAP PHYWIR TARMAU PHELAT PARSTU CHRMAR GEHMUT HEMMAB HEMFRE HETBIN GEKJAP".split()
StrataPath=""
Treefile=""
Basemlconf=""
def Readspn():
    spnfile = ""
    reSpn = {}
    h1 = open(spnfile,'r')
    for line in h1:
        comp,coms = line.strip().split()[:2]
        com,sex = comp.split('.')
        reSpn[coms] = [com,sex]
    h1.close()
    return reSpn

def ReadSDR(spns,filen):
    inputN = os.path.join(StrataPath,spns,'KeepN',filen)
    h1 = open(inputN,'r') 
    redict = {}
    for line in h1:
        iterms = line.strip().split()
        chrs,start,ends = iterms
        if chrs not in redict:
            redict[chrs] = []
        redict[chrs] += [int(start),int(ends)]
    h1.close()
    return redict

def Mkcpath(path):
    if os.path.exists(path):
        command = "setfacl -R -m user:dipseq:rwx %s"%(path)
    else:
        command = "mkdir -p %s"%(path)
    os.system(command)

def WriteTree(infile,rmls,repldict):
        if rmls:
            pls = ",".join(['%s_A'%(i) for i in rmls])
            commda = "tree_doctor -p %s -n %s | sed 's/[:|0]//g'"%(pls,Treefile)
        else:
            commda = "cat %s"%(Treefile)
        f = os.popen(commda)
        tree = f.readlines()[0].strip()
        for k,v in repldict.items():
            tree = tree.replace(k,v)
        outs = open(infile,'w')
        outs.write('%s'%(tree))
        outs.close()

def Confirmsex(spn,region,SDRbedf):
    if spn not in SDRregionDict:
        inSDRf = os.path.join(StrataPath,spn,'KeepN',SDRbedf)
        redics = ReadSDR(spn,inSDRf)
        SDRregionDict[spn] = redics
    SDRbeddict = SDRregionDict[spn]
    chrs,start,end = region
    if chrs not in SDRbeddict:
        return False
    Regls = SDRbeddict[chrs]
    Reback = False
    for subrels in Regls:
        a,b = Regls
        Sortls = list(sorted([a,b,start,end]))
        indexa,indexb,indexstart,indexend = [Sortls.index(i) for i in [a,b,start,end]]
        if indexb - indexa != 1 or indexend - indexstart != 1:
            Reback = True
            break
    return Reback

def WriteAlignf_Bio(indict,outf):
    redis = {}
    fasta = ""
    for spn,alignseqls in indict.items():
        compspn,sety = ComparespnDict[spn]
        h,t = list(sety) if sety != "TSD" else [False,False]
        ReDict = {}
        redis[spn] = []
        if len(alignseqls) == 2:
            for subls in alignseqls:
                spnk = subls[0].split('.')
                if "_" in spnk[0]:
                    chrK = '%s_%s'%(spn,t)
                else:
                    chrK = '%s_%s'%(spn,h)
                fasta += ">%s\n%s\n"%(chrK,subls[-1])
                redis[spn].append(chrK)
            continue
        spnchrid,Start,alinl,direct,scaffl,alignseq = alignseqls[0]
        chrID = spnchrid.split('.')[0]
        if h == False:
            fasta += ">%s_A\n%s\n"%(spn,alignseq)
            redis[spn].append('%s_A'%(spn))
            continue
        if direct == "+":
            End = int(Start) + int(alinl) - 1
        else:
            End = int(scaffl) - int(Start) + 1
            Start = End - int(alinl) + 1
        SDRfilen = "nonPAR%s.bed"%(h)
        Chrtys = Confirmsex(compspn,[chrID,int(Start),End],SDRfilen)
        print(Chrtys)
        chrk = '%s_%s'%(spn,h) if Chrtys else '%s_A'%(spn) 
        redis[spn].append(chrk)
        fasta += ">%s\n%s\n"%(chrk,alignseq)
    #Wfasta = AlignIO.parse(io.StringIO(fasta), 'fasta')
    #AlignIO.write(Wfasta,outf,'phylip')
    return redis

def WriteAlignf(indict,outf):
    redis = {}
    fasta = {}
    for spn,alignseqls in indict.items():
        compspn,sety = ComparespnDict[spn]
        h,t = list(sety) if sety != "TSD" else [False,False]
        ReDict = {}
        redis[spn] = []
        if len(alignseqls) == 2:
            for subls in alignseqls:
                spnk = subls[0].split('.')
                if "_" in spnk[0]:
                    chrK = '%s_%s'%(spn,t)
                else:
                    chrK = '%s_%s'%(spn,h)
                fasta[chrK] = subls[-1]
                redis[spn].append(chrK)
            continue
        spnchrid,Start,alinl,direct,scaffl,alignseq = alignseqls[0]
        chrID = spnchrid.split('.')[1]
        if h == False:
            fasta['%s_A'%(spn)] = alignseq
            redis[spn].append('%s_A'%(spn))
            continue
        if direct == "+":
            End = int(Start) + int(alinl) - 1
        else:
            End = int(scaffl) - int(Start) + 1
            Start = End - int(alinl) + 1
        SDRfilen = "nonPAR%s.bed"%(h)
        Chrtys = Confirmsex(compspn,[chrID,int(Start),End],SDRfilen)
        chrk = '%s_%s'%(spn,h) if Chrtys else '%s_A'%(spn)
        redis[spn].append(chrk)
        fasta[chrk] = alignseq
    PHYwirte(fasta,outf)
    return redis

def PHYwirte(wrdict,oufs):
    number = len(wrdict)
    ilterk = list(wrdict.items())
    length = len(ilterk[0][1])
    Outf = open(oufs,'w')
    Outf.write('%d %d\n'%(number,length))
    for subwls in ilterk:
        chris,algns = subwls
        Outf.write('%s  %s\n'%(chris,algns))
    Outf.close()

def Write_Command(Dict,fimid):
    global filterlength,Outpath,Markspn
    Fil1 = int(Dict[Markspn][0][2])
    if Fil1 < filterlength:
        return 0
    workpath = os.path.join(Outpath,'Align%s'%(fimid))
    Mkcpath(workpath)
    workshll = os.path.join(workpath,"RunbasemlRxmal.sh")
    Outwritf = open(workshll,'w')
    Outwritf.write('cd %s\n'%(workpath))
    Usedspn = list(Dict.keys())
    Removespn = list(set(Allspnls) - set(Usedspn))
    Alignfile = os.path.join(workpath,'Alignment.phy')
    Nowtreefile = os.path.join(workpath,'species.nwk')
    Backdict = WriteAlignf(Dict,Alignfile)
    replaceDict = {}
    for unspn in Backdict:
        if unspn in ['CORSAR','CORCIL']:
            continue
        replacek = '(%s,%s)'%(Backdict[unspn][0],Backdict[unspn][1]) if len(Backdict[unspn]) == 2 else Backdict[unspn][0]
        if replacek != "%s_A"%(unspn):
            replaceDict['%s_A'%(unspn)] = replacek
            continue
    if "CORSAR" in Backdict and "CORCIL" in Backdict:
        if len(Backdict['CORSAR']) == 1 and len(Backdict['CORCIL']) == 1:
            replaceDict['CORSAR_A'] = Backdict['CORSAR'][0]
            replaceDict['CORCIL_A'] = Backdict['CORCIL'][0]
        elif len(Backdict['CORSAR']) == 2 and len(Backdict['CORCIL']) == 2:
            replaceDict['CORCIL_A,CORSAR_A'] = '(CORSAR_Z,CORCIL_Z),(CORSAR_W,CORCIL_W)'
        else:
            W = 0 
            Z = 0 
            for St in Backdict['CORSAR'] + Backdict['CORCIL']:
                ks = St.split('_')[0]
                if ks == "W":
                    W += 1
                else:
                    Z += 1
            if W == 2:
                replace = "(CORSAR_W,CORCIL_W),CORSAR_Z" if len(Backdict['CORSAR']) == 2 else "(CORSAR_W,CORCIL_W),CORCIL_Z"
            if Z == 2:
                replace = "(CORSAR_W,CORCIL_W),CORSAR_Z" if len(Backdict['CORSAR']) == 2 else "(CORSAR_W,CORCIL_W),CORCIL_Z"
            replaceDict['CORCIL_A,CORSAR_A'] = replace
    else:
        if 'CORSAR' in Backdict:
            reppace = "(CORSAR_Z,CORSAR_W)" if len(Backdict['CORSAR']) == 2 else Backdict['CORSAR'][0]
            replaceDict['CORSAR_A'] = reppace
        if 'CORCIL' in Backdict:
            reppace = '(CORCIL_Z,CORCIL_W)' if len(Backdict['CORCIL']) == 2 else Backdict['CORCIL'][0]
            replaceDict['CORCIL_A'] = reppace
    WriteTree(Nowtreefile,Removespn,replaceDict)
    Outwritf.write('ln -s %s\n'%(Basemlconf))
    Outwritf.write('baseml Baseml.ctl\n')
    Outwritf.write('raxmlHPC -f a -x 12345 -p 12345 -# 100 -m PROTGAMMALGX -s Alignment.phy -n ex -T 1')
    Outwritf.close()
    Mkcpath(workpath)
    print('sh %s'%(workshll))

def main():
    global ComparespnDict,SDRregionDict,filterlength,Outpath,Markspn
    rawfile,Outpath,filterlength,Markspn = sys.argv[1:]
    ComparespnDict = Readspn()
    SDRregionDict = {}
    filterlength = int(filterlength)
    inpf = open(rawfile,'r')
    famid = 0
    Writedict = {}
    for line in inpf:
        if line.startswith('#'):
            continue
        if line.startswith('a'):
            if Writedict:
                 Write_Command(Writedict,famid)
            famid += 1
            Writedict = {}
            continue
        if line.startswith('s'):
            iterms = line.strip().split()
            spn = re.split(r'\.|_',iterms[1])[0]
            if spn not in Writedict:
                Writedict[spn] = []
            Writedict[spn].append(iterms[1:])
    inpf.close()
    Write_Command(Writedict,famid)

if __name__ == "__main__":
    main()
