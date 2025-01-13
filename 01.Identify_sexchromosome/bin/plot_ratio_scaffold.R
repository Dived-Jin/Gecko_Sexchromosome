args = commandArgs(T)
pdf(args[2], height=3, width=12)
library(ggplot2)

dat = read.table(args[1], sep = "\t", head = T)
#dat = dat[dat$sex == "f/m", ]
#max = max(dat$depth)
#pos = read.table(args[3], sep = "-")
if(args[3] == 'ZW'){
	name = 'm/f'
} else{
	name = 'f/m'
}
scaf <- unlist(strsplit(basename(args[1]),"[.]"))[1]
win = dat[1,2]-dat[1,1]
title = paste(scaf, "( win =", win, "bp )", sep = " ")

p = ggplot(dat, aes(x = start,y = ratio, colour = sex)) + geom_line(alpha = 0.5) + facet_grid(type ~ .) + scale_y_continuous(limits=c(0, 2.5)) + scale_colour_manual(values=c("#00BA38" , "#F8766D", "#619CFF"), limits=c(name, 'female', 'male'))

p = p + ylab("Value") + xlab("Coordinate (bp)") + ggtitle(title)
#for(i in 1:nrow(pos)){
#	bg = pos[i,1]
#	ed = pos[i,2]
#	p = p + annotate("rect", xmin=bg, xmax=ed, ymin=0, ymax=4, alpha = 0.5, fill = "#ffff33")
#}

plot(p)
