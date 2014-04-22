fname<-paste("Figs/FACE.Soil.moist_5cm_ring.",
             months(max(ring.means$Date),abbreviate=TRUE),year(max(ring.means$Date)),
             ".pdf",sep="")
pdf(file=fname,height=8,width=16)
par(mfrow=c(1,1),mar=c(4,8,2,1), oma=c(0,0,0,0))
with(ring.means,plot(moist*100~Date,type="n",axes=F,ann=F))
for (i in 1:6){
  with(ring.means,points(moist[ring==levels(ring)[i]]*100~Date[ring==levels(ring)[i]],type="l",
                         lwd=3,col=as.numeric(levels(ring))[i]))
}
legend("topleft",legend=paste("Ring",levels(ring.means$ring),sep="_"),
       lwd=3,col=levels(ring.means$ring),bty="o",cex=2)  
axis(2,las=1,cex.axis=2)
mtext(2,text="Soil moisture at 5 cm",line=6, cex=2)
mtext(2,text="(% of volumetric water content)",line=4, cex=2)
#time axis
timer<-range(ring.means$Date)
axis.Date(1,at=seq(timer[1],timer[2],by="month"),las=1,cex.axis=1.7,format="%b")
axis.Date(1,at=c(timer[1],timer[1]+months(4)),las=1,cex.axis=1.7,format="%y",line=2,tick=F)
box(bty="o")
dev.off()
  

