####depth of 75 cm
mo75.result<-allsoil[grep("Date$|ring|co2|Theta75",names(allsoil))]
some(mo75.result)
mo75.mean<-melt(mo75.result,id=c("Date","ring","co2"))
mo75.ring<-with(mo75.mean,aggregate(value,list(Date=Date,ring=ring,co2=co2),mean))
names(mo75.ring)
names(mo75.ring)[4]<-"moist"
mo75.ring<-mo75.ring[order(mo75.ring$Date),]
head(mo75.ring)
mo75.ring$moist<-mo75.ring$moist/100 #convert the unit to fraction
fname<-paste("Figs/FACE.Soil.moist_75cm_ring.",
             months(max(ring.means$Date),abbreviate=TRUE),year(max(ring.means$Date)),".png",sep="")
png(file=fname,height=600,width=1200)
moist_graph.png(dataset=mo75.ring,title="Soil moisture at 75 cm",legend.location="bottomleft")
dev.off() 


