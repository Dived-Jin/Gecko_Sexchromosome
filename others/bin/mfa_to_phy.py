#!/usr/bin/env python3

def main():
        import sys
        from Bio import AlignIO

        if len(sys.argv) != 5:
                sys.exit('python3 %s <in.mfa> <out.mfa> <inFormat> <outFormat>' % (sys.argv[0]))

        inFile = sys.argv[1]
        outFile = sys.argv[2]
        inFormat = sys.argv[3]
        outFormat = sys.argv[4]

        alignments = AlignIO.parse(inFile, inFormat)
        AlignIO.write(alignments, outFile, outFormat)


if __name__ == '__main__':
        main()
