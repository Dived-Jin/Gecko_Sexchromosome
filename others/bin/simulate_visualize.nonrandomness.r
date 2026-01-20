args = commandArgs(T)

library(ggplot2)
library(XNomial)

inFile = args[1]
pdfFile = args[2]
outFile = args[3]

dat = read.table(inFile)
pdf(pdfFile, w=16, h=4)

obs = dat$V3
exp = dat$V4

#test = xmonte(obs, exp, detail=3)
#print(test)

n = sum(obs)
replicates = 10000
count = NULL
set.seed(1234)
print(Sys.time())
for(i in 1:replicates){
        sampled = sample(dat$V1, n, replace = T, prob = exp/sum(exp))
        count1 = as.data.frame(table(factor(sampled, levels = dat$V1)))
        count = rbind(count, count1)
}
print(Sys.time())
MAX = max(count$Freq, obs)
ggplot() + geom_violin(data = count, aes(x=Var1, y=Freq)) + geom_point(data = dat, aes(x=V1, y=V3)) + scale_y_continuous(limits = c(0, MAX)) + labs(x='GAC', y='#Times recruited as sex chr.') + scale_x_discrete(limits = dat$V1) + theme_bw()

ggplot() + geom_bar(data = dat, aes(x=V1, y=V4), stat = 'identity') + scale_x_discrete(limits = dat$V1) + theme_bw() + labs(x='GAC', y='')

df = data.frame()
for(i in 1:length(dat$V1)){
        gac = dat$V1[i]
        #print(count$Freq[count$Var1==gac])
        #wilcox = wilcox.test(dat$V3[dat$V1==gac], count$Freq[count$Var1==gac], alternative = 'greater')
        #df = rbind(df, data.frame(gac, wilcox$p.value))
        pval = sum(count$Freq[count$Var1==gac]>=dat$V3[dat$V1==gac])/nrow(count[count$Var1==gac,])
        med = median(count$Freq[count$Var1==gac])
        df = rbind(df, data.frame(gac, med, pval))
}
write.table(df, outFile, quote=F, sep="\t", row.names = F)
