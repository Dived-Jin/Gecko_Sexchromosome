import sys,os
def Readfile(files):
	with open(files,'r') as h1:
		relis = [i.strip() for i in h1]
	h1.close()
	return relis

def main():
	Rawinputl = sys.argv[1:]
	inputfile = open(Rawinputl[0],'r')
	Nfile = Rawinputl[1]
	filterRate = float(Rawinputl[2])
	outfile = open(Rawinputl[3],'w')
	Spelis = inputfile.readline().split()[1:]
	if os.path.isfile(Nfile):
		UsedLs = Readfile(Nfile)
		UsedspeN =  len(UsedLs)
	else:
		UsedLs = Spelis
		UsedspeN = int(Nfile)
	for line in inputfile:
		iterms = line.strip().split()
		alignls = iterms[1:]
		lcaodic = dict(zip(Spelis,alignls))
		full = 0
		for spn in UsedLs:
			vals = float(lcaodic[spn])
			if vals >= filterRate:
				full += 1
		print(full)
		if full == UsedspeN:
			outfile.write('%s\n'%("\t".join(iterms)))
	inputfile.close()
	outfile.close()
if __name__ == "__main__":
	main()
