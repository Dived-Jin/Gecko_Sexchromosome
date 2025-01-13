# _*_ encoding: utf-8 _*_
'''
@File : Splitmp.py
@TIME : 2023/06/01 13:CURRENT_MONUTE:54
@AUTHOR : Jin Jiazheng
@VERSION : 1.0
@Contact : jinjiazhengxiao@163.com
@LISCENCE : None
'''

# here put the import lib
import sys,os 
def Mkcdir(dirs):
    if os.path.exists(dirs):
        return 0
    os.system('mkdir -p %s'%(dirs)) 

def Checkown(ls):
    global markS,Tilelist,outdir
    for sublin in ls:
        iterms = sublin.strip().split()
        if markS in iterms[1]:
            scaffoldid = iterms[1].split('.')[1]
            break
    if scaffoldid not in Dictfile:
        oum = open("%s/%s.U.mp"%(outdir,scaffoldid),'w')
        Dictfile[scaffoldid] = oum
        oum.write('%s'%(''.join(Tilelist)))
    osf = Dictfile[scaffoldid]
    osf.write('%s'%(''.join(ls)))

def main():
    global Dictfile,Tilelist,markS,outdir
    Dictfile = {}
    mpfile,outdir,markS = sys.argv[1:]
    Mkcdir(outdir)
    Tilelist = []
    f1 = open(mpfile,'r')
    for line in f1:
        if line.startswith("#"):
            Tilelist.append(line)
        else:
            K = line
            break
    inli = [K]
    for line in f1:
        if line.startswith('#'):
            continue
        if line.startswith("a score="):
            Checkown(inli)
            inli = [line]
        else:
            inli.append(line)
    f1.close()
    for k,v in Dictfile.items():
        v.write('#eof maf')
        v.close()

if __name__ == "__main__":
    main()