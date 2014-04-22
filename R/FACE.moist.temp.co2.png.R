fname<-paste("output/Figs/FACE.most.temp.co2.",
             months(max(ring.means$Date),abbreviate=TRUE),year(max(ring.means$Date)),".png",sep="")
png(file=fname,height=600,width=1200) #save a graph as png
par(mfrow=c(1,1),mar=c(4,8,0.5,12.5), oma=c(0,0,0,0)) #set margnin, the number of graphs to plot
#plot moisture
plot(moist*100~Date,type="n",axes=F,ylim=c(0,0.5*100),xlab="",ylab="",co.rain_means)
points(moist[co2=="elev"]*100~Date[co2=="elev"],type="l",lwd=2,lty=2,co.rain_means)
points(moist[co2=="amb"]*100~Date[co2=="amb"],type="l",lwd=2,co.rain_means)
axis(2,las=1,cex.axis=2)

#plot temp
par(new=TRUE) #overlay the plot on the previouis one
plot(temp~Date,type="n",ylim=c(0,27),axes=F,xlab="",ylab="",co.rain_means)
points(temp[co2=="elev"]~Date[co2=="elev"],type="l",lwd=2,lty=2,col="red",co.rain_means)
points(temp[co2=="amb"]~Date[co2=="amb"],type="l",lwd=2,col="red",co.rain_means)
axis(4,las=1,cex.axis=2)
#time axis
timer<-range(co.rain_means$Date)
axis.Date(1,at=seq(timer[1],timer[2],by="month"),las=1,cex.axis=1.7,format="%b")
axis.Date(1,at=c(timer[1],timer[1]+months(7)),las=1,cex.axis=1.7,format="%y",line=2,tick=F)

box(bty="o")
mtext(2,text="Soil moisture at 5 cm",line=6, cex=2)
mtext(2,text="(% of volumetric water content)",line=4, cex=2)
mtext(4,text=expression(Soil~temperature~at~5~cm~(degree~C)),line=4.5, cex=2)
legend("top",
       leg=c("Temperature at amb",
             expression(Temperature~at~eCO[2]),
             "Moisture at amb",
             expression(Moisture~at~eCO[2])),
       lwd=2,col=c(2,2,1,1),lty=c(1,2,1,2),bty="n",cex=2)

#plot rainfall
par(new=TRUE)
plot(Rain_mm_Tot~Date,type="h",lwd=2,data=co.rain_means,ylim=c(0,155),col="gray",lend=2,
     ylab="",xlab="",axes=F)
#lend=2: defining the type of the line-end no to show value 0
axis(side=4,las=1,at=seq(0,150,20),labels=c(seq(0,150,20)),cex.axis=2,line=6.5)
mtext(4,text="Precipitation (mm)",line=10.5, cex=2) 

dev.off()

