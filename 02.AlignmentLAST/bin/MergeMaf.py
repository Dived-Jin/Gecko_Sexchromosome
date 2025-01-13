# _*_ encoding: utf-8 _*_
'''
@File : Command.py
@TIME : 2023/06/01 13:CURRENT_MONUTE:50
@AUTHOR : Jin Jiazheng
@VERSION : 1.0
@Contact : jinjiazhengxiao@163.com
@LISCENCE : None
'''

# here put the import lib
import sys,os,glob
MUlzpath=""
def Mkcdir(dirs):
    if os.path.exists(dirs):
        return 0
    os.system('mkdir -p %s'%(dirs))
def galobfiln(dirs):
    ls = glob.glob(dirs+"/*.U.mp")
    rels = [os.path.basename(i) for i in ls]
    return rels 
def main():
    dir1,dir2,Refspn,dir3,outshell = sys.argv[1:]
    Mkcdir(dir3)
    outs = open(outshell,'w')
    dil1 = galobfiln(dir1)
    dil2 = galobfiln(dir2)
    filen = list(set(dil1+dil2))
    for kn in filen:
        f1 = dir1+ "/%s"%(kn)
        f2 = dir2+ "/%s"%(kn)
        Kn1 = kn.strip().split('.')[0]
        ex1 = os.path.exists(f1)
        ex2 = os.path.exists(f2)
        o1 = dir3 +"/" + dir3 + ".%s.mp"%(Kn1)
        ou1 = dir3 +"/" + dir1 + ".%s.u.mp"%(Kn1)
        ou2 = dir3 +"/" + dir2 + ".%s.u.mp"%(Kn1)
        ou3 = dir3 +"/" + dir3 + ".%s.U"%(Kn1)
        ou4 = dir3 +"/" + "%s"%(kn)
        if ex1 and ex2:
            outs.write('%s/multiz %s %s 1 %s %s >%s && grep -v -h eof %s %s %s >%s && %s/maf_project %s %s %s.0 >%s\n'%(MUlzpath,f1,f2,ou1,ou2,o1,o1,ou1,ou2,ou3,MUlzpath,ou3,Refspn,ou3,ou4))
        else:
            print(f1,f2)
            if ex1:
                outs.write('cp %s %s\n'%(f1,ou4))
            else:
                outs.write('cp %s %s\n'%(f2,ou4))
    outs.close()
if __name__ == "__main__":
    main()
