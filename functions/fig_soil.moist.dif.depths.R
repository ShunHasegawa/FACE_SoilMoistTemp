# subset moisture data from different layers
moist.depths <- ring.means[ ,grep("Date$|ring|Theta", names(ring.means))]

moist.depths.mlt <- melt(moist.depths, id = c("Date", "ring"))

# subset required data

png(file=fname,height=600,width=1200)


moist_graph.png(dataset=ring.means,title="Soil moisture at 5 cm",legend.location="topleft") #title: yaxis title


dev.off()