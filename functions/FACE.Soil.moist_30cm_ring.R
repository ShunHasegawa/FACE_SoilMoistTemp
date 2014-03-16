#moistyre at a depth of 30 cm

#function which extract specified parameters from a dataset
ex_variable <- function(data,variables){
  result <- data[grep(variables,names(data))]
  means <- melt(result,id=c("Date","ring","co2"))
  ring_mean<-with(means,aggregate(value,list(Date=Date,ring=ring,co2=co2),mean))
  names(ring_mean)[4]<-"moist"
  ring_mean<-ring_mean[order(ring_mean$Date),]
  head(ring_mean)
  ring_mean$moist<-ring_mean$moist/100 #convert the unit to fraction
  return(ring_mean)
}

#############


DeepSoilMoist_graphs <- function(filename,parameters,savefile,figname,figtitle){
  if(!file.exists(savefile)){
    filename <- ex_variable(data=allsoil,variables=parameters)
    save(filename,file=savefile)
    } else{
    newdata <- ex_variable(data=newsoilData,variables=parameters)
    load(savefile)
    filename <- rbind(filename,newdata)
    filename <- filename[!duplicated(filename),]
    save(mo30.ring,file=savefile)
    }
  
  fname<-paste(figname,months(max(ring.means$Date),abbreviate=TRUE),year(max(ring.means$Date)),".png",sep="")
  png(file=fname,height=600,width=1200)
  moist_graph.png(dataset=mo30.ring,title=figtitle,legend.location="topleft")
  dev.off()
}
                                   
DeepSoilMoist_graphs(filename="mo30.ring",parameters="Date$|ring|co2|Theta30",
                     savefile="output/mo30.ring.Rdata",figname="Figs/FACE.Soil.moist_30cm_ring.",
                     figtitle="Soil moisture at 30 cm")
summary(mo30.ring)


#############


















#soil moisture at 30 cm
if(!file.exists("mo30.ring")){
  mo30.ring <- ex_variable(data=allsoil,variables="Date$|ring|co2|Theta30")
  save(mo30.ring,file="output/mo30.ring.Rdata")
} else{
  newdata <- ex_variable(data=newsoilData,variables="Date$|ring|co2|Theta30")
  load("mo30.ring.Rdata")
  mo30.ring <- rbind(mo30.ring,newdata)
  save(mo30.ring,file="output/mo30.ring.Radata")
}

fname<-paste("Figs/FACE.Soil.moist_30cm_ring.",
             months(max(ring.means$Date),abbreviate=TRUE),year(max(ring.means$Date)),".png",sep="")
png(file=fname,height=600,width=1200)
moist_graph.png(dataset=mo30.ring,title="Soil moisture at 30 cm",legend.location="topleft")
dev.off()

#soil moisture at 75 cm
if(!file.exists("mo75.ring")){
  mo75.ring <- ex_variable(data=allsoil,variables="Date$|ring|co2|Theta75")
  save(mo75.ring,file="output/mo75.ring.Rdata")
} else{
  newdata <- ex_variable(data=newsoilData,variables="Date$|ring|co2|Theta75")
  load("mo75.ring.Rdata")
  mo75.ring <- rbind(mo75.ring,newdata)
  save(mo75.ring,file="output/mo75.ring.Radata")
}

fname<-paste("Figs/FACE.Soil.moist_75cm_ring.",
             months(max(ring.means$Date),abbreviate=TRUE),year(max(ring.means$Date)),".png",sep="")
png(file=fname,height=600,width=1200)
moist_graph.png(dataset=mo75.ring,title="Soil moisture at 75 cm",legend.location="topleft")
dev.off()


