library(ggplot2)
set.seed(123)
spn_divergencetime <- c(60.93,37.71,48.39,67.90,33.62,80.58,74.70,63.88,73.7,46.10,46.10)
Sexstart_time <- c(7.34,20.26,0,18.09,0,0,0,31.78,0,0,0)

##random selected
rawmatrix <- matrix(seq(1,11,by=1),nrow=1)
for (i in seq(1, 10000, by = 1)){
    localis <- c()
    for (i1 in seq(1, 11, by = 1)){
        S <- Sexstart_time[i1]
        E <- spn_divergencetime[i1]
        ele <- runif(1,min=S,max=E)
        localis <- c(localis,ele)
    }
    localM <- matrix(localis,nrow=1)
    rawmatrix <- rbind(rawmatrix,localM)
}

#### 7 <= sex divergence Time <=12
regionls <- c()
for (i in 2:nrow(rawmatrix)){
    m <- rawmatrix[i,]
    n <- sum(m>=7 & m<=12)#/length(m)
    regionls <- c(regionls,n)
}
m <- data.frame(percent = regionls)
p <- paste("p-value = ",sum(regionls>=5)/length(regionls),sep="")
pdf('simulate.7-12.pdf')
ggplot(m,aes(x=percent)) + geom_bar(width=1) + geom_vline(xintercept=c(5),color =c("red"), linetype = "dashed") + xlim(-0.5,11) + theme_bw() +
annotate('text',x=8,y=3000,label=p,size=6,color='black') + labs(x="Number",y="Times",size=6) + theme(axis.title.x = element_text(size = 14, color = "red", face = "bold"),axis.title.y = element_text(size = 14, color = "blue", angle = 0))
dev.off()

###### statistic
breakpoint <- seq(0,60,by=5)
Sexdivergence <- c(8.26,28.79,11.52,54.45,7.13,5.90,13.52,33.99,12.71,11.95,8.89)
Point <- c(2.5,7.5,12.5,17.5,22.5,27.5,32.5,37.5,42.5,47.5,52.5,57.5)
freq = matrix(Point,nrow=1)
for (i in 2:nrow(rawmatrix)){
    m = rawmatrix[i,]
    k1 = cut(m, breaks = breakpoint, include.lowest = TRUE)
    #print(as.data.frame(table(k1))$Freq)
    m1 = matrix((as.data.frame(table(k1))$Freq),nrow=1)
    length(m1)
    freq = rbind(freq,m1)
}

upperls <- c()
downls <- c()
Medians <- c()
for (i in seq(1, 12, by = 1)){
    ls <- freq[,i][2:10001]
    ls_sort <- sort(ls)
    a <- median(ls_sort)
    up <- ls_sort[9500]
    down <- ls_sort[500]
    upperls <- c(upperls,up)
    download <- c(download,down)
    Medians <- c(Medians,a)
}

df_stat_simulate <-  data.frame(point=Point, up=upperls,down=downls,m=Medians)
df_stat_raw <- data.frame(a = Sexdivergence)
pdf('Simulation.each_windown.pdf')
ggplot() + geom_ribbon(data=dfm,aes(x=point,ymin=down,ymax=up),fill = "steelblue", alpha = 0.3) + 
geom_histogram(data=dfk,aes(x=a),binwidth = 5,boundary = 0) + 
ylim(0,5) + xlim(0,60)+theme_bw()
dev.off()
