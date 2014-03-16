#windows(7,7,rescale="fixed")
pdf("Figs/FACE.annual.soil.moisture_mean.pdf",
    height=7,width=7)
par(mar=c(3,3,3,0.5), oma=c(0,0,0,0))
xv<-barplot(an.mean$mean,col=as.numeric(levels(an.mean$ring)),
            ylim=c(0,max(pretty(an.mean$mean+an.mean$se))+2),
            axes=F,main=paste("Annual_mean(n=8)",min(soil.mo.mean$Date),
                              max(soil.mo.mean$Date),sep="-"),cex.main=1)
with(an.mean,arrows(xv[,1],mean+se,xv[,1],mean-se,code=3,angle=90,length=0.2,lwd=3))
axis(2,cex.axis=2,las=1)
axis(1,cex.axis=2,at=xv,lab=levels(an.mean$ring))
box(bty="o")
with(an.mean,text(xv,mean+se,labels=round(an.mean$mean,1),cex=2,pos=3))
dev.off()
