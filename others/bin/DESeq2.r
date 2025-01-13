library( "DESeq2" )

args = commandArgs(T)
inFile = args[1]
metaFile = args[2]
outFile = args[3]

countData <- read.table(inFile, header = TRUE, sep = "\t")
head(countData)

metaData = read.table(metaFile, h=F, sep = "\t")
colnames(metaData) = c('ID', 'sex', 'tissue')

dds <- DESeqDataSetFromMatrix(countData=countData, colData=metaData, design=~sex+tissue, tidy = TRUE)
dds = dds[rowSums(counts(dds)) > 1, ]
#nrow(dds)
a <- DESeq(dds)

#res = results(dds)
normalized_counts = counts(a, normalized=T)
write.table(normalized_counts, file=outFile, sep="\t", quote=F, col.names=NA)

