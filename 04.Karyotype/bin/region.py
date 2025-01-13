import sys,os
a = "CORSAR CORCIL PYGNIG NEPLEV EUBMAC COLBRE ARIPRA SPHMIN THERAP PHYWIR TARMAU CHRMAR PHELAT PARSTU GEHMUT  HEMFRE HEMMAB HETBIN GEKJAP"
#a = "CORSAR CORCIL PYGNIG NEPLEV EUBMAC COLBRE ARIPRA SPHMIN TARMAU PHYWIR THERAP HEMMAB HEMFRE CHRMAR PHELAT PARSTU GEHMUT HETBIN GEKJAP"
#a = "HEMFRE HEMMAB GEHMUT CHRMAR PARSTU PHELAT"
spnls = a.strip().split()
subs = [spnls[i:i+2]for i in range(len(a))]
kn1 = 1
knc = 0
for i in spnls:
	knc += 1
	print("GenomeInfoFile%s=rawfile1/%s.len"%(knc,i))
for ksub in subs:
	if len(ksub) != 2:
		continue
    	kn1 += 1
	k1,k2= ksub 
	outs2 = 'rawfile1/%s_%s.link'%(k1,k2)
	os.system('python split.py %s %s %s'%(k1,k2,outs2))
	print('LinkFileRef1VsRef%s=rawfile1/%s_%s.link'%(kn1,k1,k2))
    #lne1 = "rawfile/%s.len"%(k1)
    #outconf = open('%s.conf'%(k1),'w')
    #outconf.write('SetParaFor = global\nGenomeInfoFile1=%s\nGenomeInfoFile2=%s\nGenomeInfoFile3=%s\nLinkFileRef2VsRef1=%s\nLinkFileRef2VsRef3=%s\n'%(lne1,lne2,lne3,outs1,outs2))
    #outconf.close()
