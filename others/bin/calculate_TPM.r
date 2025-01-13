args = commandArgs(T)

inFile = args[1]
outFile = args[2]

dat = read.table(inFile, h=T)

dat1 = dat[,1:(ncol(dat)-1)] 
len = dat[ncol(dat)]

dat2 = apply(dat1, 2, function(x){x/len})
dat3 = data.frame(dat2)
colnames(dat3) = names(dat2)

sums = colSums(dat3)

mat = t(apply(dat3, 1, function(x){x/sums}))*1e6
Sample = rownames(mat)
mat = cbind(Sample, mat)

write.table(mat, outFile, quote = F, sep = "\t", row.names = F, col.names = T)

