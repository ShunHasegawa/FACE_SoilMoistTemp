#windows(7,7,rescale="fixed")
pdf("Figs/FACE.annual.soil.moisture_mean.pdf",
    height=7,width=7)
par(mar=c(3,3,3,0.5), oma=c(0,0,0,0))
xv<-barplot(an.mean$Mean,col=as.numeric(levels(an.mean$ring)),
            ylim=c(0,max(pretty(an.mean$Mean+an.mean$SE))+2),
            axes=F,main=paste("Annual_mean(n=8)",min(soil.mo$Date),
                              max(soil.mo$Date),sep="-"),cex.main=1)
with(an.mean,arrows(xv[,1], Mean+SE, xv[,1], Mean-SE, code=3, angle=90, length=0.2, lwd=3))
axis(2,cex.axis=2,las=1)
axis(1,cex.axis=2,at=xv,lab=levels(an.mean$ring))
box(bty="o")
with(an.mean,text(xv,Mean+SE,labels=round(an.mean$Mean,1),cex=2,pos=3))
dev.off()
