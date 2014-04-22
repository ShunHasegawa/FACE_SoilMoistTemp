fname<-paste("Figs/soil.moist.temp.ring.",
             months(max(ring.means$Date),abbreviate=TRUE),
             year(max(ring.means$Date)),".png",sep="")
png(file=fname,height=1200,width=1200)
par(mfrow=c(2,1),mar=c(3,9.5,2,1), oma=c(0,0,0,0)) #number of graphs is 2
f.ring<-levels(ring.means$ring)
f.col<-c(1:6)
with(ring.means,plot(moist~Date,type="n"))
for (i in 1:6)
  with(ring.means,points(moist[ring==f.ring[i]]~Date[ring==f.ring[i]],type="l",lwd=2,col=f.col[i]))
legend("topright",leg=as.factor(c(1:6)),lwd=2,col=c(1:6),bty="o",cex=1)

with(ring.means,plot(temp~Date,type="n"))
for (i in 1:6)
  with(ring.means,points(temp[ring==f.ring[i]]~Date[ring==f.ring[i]],type="l",col=f.col[i]))
dev.off()


