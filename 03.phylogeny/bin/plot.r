library(ggplot2)
df = read.table('ILS_introng_filter.txt',head=T)
#order = c("TARMAU","PHYWIR","THERAP","CHRMAR","PHELAT","PARSTU","PARPIC","GEHMUT","HEMMAB","HEMFRE","HETBIN","LEPLIS","GEKJAP")
order = c('GEKJAP','LEPLIS', 'HETBIN', 'HEMFRE', 'HEMMAB', 'GEHMUT','PARPIC', 'PARSTU', 'PHELAT', 'CHRMAR', 'TARMAU', 'PHYWIR','THERAP',  'SPHTOW','SPHMIN','ARIPRA','COLBRE', 'EUBMAC',  'NEPLEV', 'PYGNIG', 'CORCIL', "CORSAR")
#order = c('G.japonicus', 'L.listeri', 'H.binoei', 'H.frenatus', 'H.mabouia', 'G.mutilata', 'P.picta', 'P.stumpffi', 'P.laticauda', 'C.marmoratus', 'T.rapicauda', 'P.wirshingi', 'T.mauritanica', 'A.praesignis', 'S.minigoi', 'S.townsendi', 'E.macularius', 'C.brevis', 'N.levis', 'P.nigriceps', 'C.sarasinorum', 'C.ciliatus')
#order = c()
df$speciesA = factor(df$speciesA,levels=order)
df$speciesB = factor(df$speciesB,levels=order)
dfa=df[df$Type!="Introngression",]
dfb=df[df$Type!="ILS",]
p = ggplot(dfb,aes(speciesA,speciesB,fill=ratio)) + geom_tile() + scale_fill_gradient(low="#ffffff",high="#31a354",guide="colorbar") + theme(axis.text.x = element_text(angle=90,vjust = 0.5,hjust = 0.5))
p1 = ggplot(dfa,aes(speciesA,speciesB,fill=ratio)) + geom_tile() + scale_fill_gradient(low="#ffffff",high="#49006a",guide="colorbar") + theme(axis.text.x = element_text(angle=90,vjust = 0.5,hjust = 0.5))
#geom_text(aes(label=ratio),size=1.5,color="red")
pdf('Introngression.t1py.pdf')
p
dev.off()

pdf("ILS.t1pya.pdf")
p1
dev.off()
