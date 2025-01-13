import sys,os
f1 = open(sys.argv[1],'r')
f2 = open(sys.argv[2],'a')
lenls = []
for line in f1:
	if line.startswith('a') or line.startswith('s'):
		lenls.append(line)
		print(len(lenls))
		if len(lenls) == 3:
			scor,target,query = lenls
			targels = target.strip().split()
			querls = query.strip().split()
			targels[1] = 'target.%s'%(targels[1])
			querls[1] = 'query.%s'%(querls[1])
			f2.write('%s%s\n%s\n'%(scor,"\t".join(targels),"\t".join(querls)))
			lenls = []
	else:
		f2.write('%s'%(line))
f1.close()
f2.close()
