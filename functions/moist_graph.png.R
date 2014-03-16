#function to produce png graph for soil moisture in the ring level
moist_graph.png<-function(dataset,title,legend.location) {
  par(mfrow=c(1,1),mar=c(4,9.5,2,1), oma=c(0,0,0,0))
  with(dataset,plot(moist*100~Date,type="n",axes=F,ann=F))
  for (i in 1:6){
    with(dataset,points(moist[ring==levels(ring)[i]]*100~Date[ring==levels(ring)[i]],type="l",
                        lwd=3,col=as.numeric(levels(ring))[i]))
  }
  legend(legend.location,legend=paste("Ring",levels(dataset$ring),sep="_"),
         lwd=3,col=levels(dataset$ring),bty="o",cex=2,bg="transparent")  
  axis(2,las=1,cex.axis=2)
  mtext(2,text=title,line=6, cex=2)
  mtext(2,text="(% of volumetric water content)",line=4, cex=2)
  #time axis
  timer<-range(dataset$Date)
  axis.Date(1,at=seq(timer[1],timer[2],by="month"),las=1,cex.axis=2,format="%b")
  axis.Date(1,at=c(timer[1],timer[1]+months(4)),las=1,cex.axis=2,format="%y",line=2,tick=F)
  box(bty="o")  
}