# _*_ encoding: utf-8 _*_
'''
@File : GetStrengthVale.py
@TIME : 2022/10/20 10::51
@AUTHOR : Jin Jiazheng
@VERSION : 1.0
@Contact : jinjiazhengxiao@163.com
@LISCENCE : None
'''

# here put the import lib

import sys,os,re,math
from tabnanny import check
import numpy as np
from scipy.stats import ranksums

####################################################################
# Read Marker files
####################################################################
def Readfiles(files):
    dica = {}
    with open(files,'r') as h1:
        for line in h1:
            iterms = line.strip().split()
            k = iterms[0]
            e = iterms[-1]
            dica[k] = e
    h1.close()
    return dica

######################################################################
#ReadHic bed
######################################################################
def ReadMarkbed(files):
    dica = {}
    with open(files,'r') as h1:
        for line in h1:
            iterms = line.strip().split()
            k,s,e,v = iterms
            dica[v] =  k
    h1.close()
    return dica
######################################################################
# Read Hicpro
######################################################################
def ReadHicpro(files):
    dica = {}
    TotalStrength = 0 
    with open(files,'r') as h1:
        for line in h1:
            iterms = line.strip().split()
            k1,k2,strength = iterms
            strength = float(strength)
            chr1 = Bedicta[k1]
            chr2 = Bedicta[k2]
            if chr1 not in dica:
                dica[chr1] = {}
            if chr2 not in dica:
                dica[chr2] = {}
            if chr1 not in dica[chr2]:
                dica[chr2][chr1] = 0
            if chr2 not in dica[chr1]:
                dica[chr1][chr2] = 0
            if chr1 != chr2:    
                TotalStrength += strength
            dica[chr2][chr1] += strength
            dica[chr1][chr2] += strength
    h1.close()
    print("TatalStrength:%s"%(TotalStrength))
    return dica,TotalStrength

#######################################################################
def SubCal(ks,bk):
    dica = StrengthDict.get(ks,{})
    ksintra = 0
    for k,v in dica.items():
        if k != ks:
            ksintra += v 
    return ksintra


#######################################################################
#Calculate Strength
#######################################################################
def CalculateStrenth(k1,k2):
    try:
        InterK1 = StrengthDict[k1][k2]
    except:
        InterK1 = 0
    if InterK1 == 0:
        return 0
    interK2 = SubCal(k1,k2)
    interK3 = SubCal(k2,k1)
    A1 = ((interK2/Sumstrength)*(interK3/(Sumstrength-interK2)))
    A2 = ((interK3/Sumstrength)*(interK2/(Sumstrength-interK3)))
    if A1+A2 == 0:
        return 0
    strens = float(InterK1)/((A1+A2)*(Sumstrength/2))
    return strens

#######################################################################
#Mian script
#######################################################################
def main():
    global Markerdicall,Markerdictqur,compareUncondict,Bedicta,StrengthDict,Sumstrength
    Mark1,Mark2,Mark3,hicfile,hicbed,outstafile = sys.argv[1:]
    compareSexdict = Readfiles(Mark1)
    compareAutodict = Readfiles(Mark2)
    compareUncondict = Readfiles(Mark3)
    Markerdicall = {**compareSexdict,**compareAutodict,**compareUncondict}
    Markerdictqur = {**compareSexdict,**compareAutodict}
    Bedicta = ReadMarkbed(hicbed)
    StrengthDict,Sumstrength = ReadHicpro(hicfile)
    Outfil = open(outstafile,'w')
    Outfil.write("Small_scaffold_id\tSexchromosome\tstrength\tAtuosome\tstrength\tP_valuse\tMulti\tcomfirm\tlength1\tlength2\n")
    for SmallSex in compareUncondict:
        dicSex = {}
        dicAuo = {}
        for Atuo in compareAutodict:
            str1 = CalculateStrenth(SmallSex,Atuo)
            dicAuo[Atuo] = str1
        for Sex in compareSexdict:
            str2 = CalculateStrenth(SmallSex,Sex)
            dicSex[Sex] = str2 
        Sexchrom=list(dicSex.values())
        Atuosome=list(dicAuo.values())
        try:
            if Sexchrom and Atuosome:
                lisA = (sorted(dicSex.items(),key=lambda x: x[1],reverse=True))
                SexMax,SexStrenth = lisA[0]
                #SexSecond,Secend=lisA[1]
                SexStrenthLis = Sexchrom #[SexStrenth] if Secend < 1 else [SexStrenth,Secend]
                AtoMax,AutoStrenth = (sorted(dicAuo.items(),key=lambda x: x[1],reverse=True))[0]
                lenk1 = len(SexStrenthLis);lenk2=len(Atuosome);s, pval = ranksums(SexStrenthLis,Atuosome,alternative="greater")
                pval = round(float(pval),4)
                Cons = Markerdicall[SmallSex]
                Multi = round(SexStrenth/AutoStrenth,4) if AutoStrenth != 0 else 0
            else:
                SexMax,SexStrenth,AtoMax,AutoStrenth,pval,Multi,Cons,lenk1,lenk2 = ["NA","NA","NA","NA","NA","NA","NA","NA","NA"]
            Outfil.write('%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n'%(SmallSex,SexMax,SexStrenth,AtoMax,AutoStrenth,pval,Multi,Cons))
        except:
            print("Eorro\t",SmallSex)
            print(Sexchrom)
            print(Atuosome)
            pass
    Outfil.close()
#######################################################################
if __name__ == "__main__":
    main()
