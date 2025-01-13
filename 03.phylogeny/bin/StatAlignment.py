import sys,os,pysam
import time
Exculedm = ['-','n','N']
def main():
	speciesf,fasta,outfile,Length,preIDs = sys.argv[1:]
	with open(speciesf,'r') as h1:
		SpeciesLs = [i.strip() for i in h1]
	h1.close()
	Fast = pysam.Fastafile(fasta)
	outf = open(outfile,'w')
	mark = SpeciesLs[0]
	lensa = len(Fast.fetch(mark))
	Windows = [[i,i+int(Length)] for i in range(0,lensa,int(Length))]
	outf.write('ID\t%s\n'%('\t'.join(SpeciesLs)))
	for echw in Windows:
		star,end = echw
		if end >lensa:
			end = lensa
		keplen = end - star
		ratio = float(keplen)/float(Length)
		if ratio < 0.8:
			continue
		IDs = '%s_%s_%s'%(preIDs,star,end)
		wirtels = [IDs]
		for spn in SpeciesLs:
			try:
				seq = Fast.fetch(region="%s:%s-%s"%(spn,star+1,end))
			except:
				seq = "-" * keplen
			exn = 0
			for i in Exculedm:
				exn += seq.count(i)
			alignr = round(float(keplen-exn)/float(keplen),4)
			wirtels.append(str(alignr))
		outf.write('%s\n'%("\t".join(wirtels)))
	outf.close()
if __name__ == "__main__":
	main()
