fname<-paste("Figs/FACE.Soil.moist_5cm_ring.",
               months(max(ring.means$Date),abbreviate=TRUE),
               year(max(ring.means$Date)),".png",sep="")
png(file=fname,height=600,width=1200)
moist_graph.png(dataset=ring.means,title="Soil moisture at 5 cm",legend.location="topleft") #title: yaxis title
dev.off()

