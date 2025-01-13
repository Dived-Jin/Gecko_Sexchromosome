library(qqman)
library(ggplot2)
argv = commandArgs(T)
input = argv[1]
sexchr = argv[2]
out1 = argv[3]
out2 = argv[4]

fst <- read.table(input,header=TRUE)
fstsubset <- fst[complete.cases(fst),]
SNP <- c(1:(nrow(fstsubset)))
mydf <- data.frame(SNP,fstsubset)
mydf <- mydf[mydf$WEIGHTED_FST>0, ]
dfs=fst[fst$WEIGHTED_FST >0, ]
mas = max(dfs$WEIGHTED_FST) + 0.1
myout <- quantile(dfs$WEIGHTED_FST,c(0.95))
pdf(out1)
manhattan(mydf,chr="CHROM",bp="BIN_END",p="WEIGHTED_FST",ylim = c(0,mas),snp="SNP",logp=FALSE,ylab="Fst",col=c("blue4",'orange3'),suggestiveline = myout,nnotateTop=TRUE, cex = 1.2,)
dev.off()

Useddf <- mydf[mydf$CHROM==sexchr,]
pdf(out2)
manhattan(Useddf,chr="CHROM",bp="BIN_END",p="WEIGHTED_FST",ylim = c(0,mas),snp="SNP",logp=FALSE,ylab="Fst",col=c("blue4",'orange3'),suggestiveline = myout,nnotateTop=TRUE, cex = 1.2)
dev.off()
