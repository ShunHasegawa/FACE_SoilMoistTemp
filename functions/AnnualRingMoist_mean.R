#annual ring mean moisture

#extract soil moisture data
soil.mo.mean<-allsoil[,grep("VWC|ring|Date$|co2",names(allsoil))]
head(soil.mo.mean)
summary(soil.mo.mean)

#annual ring mean
vals<-names(soil.mo.mean)[grep("VWC",names(soil.mo.mean))]
an.ring<-with(soil.mo.mean,aggregate(soil.mo.mean[vals],
                                     list(ring=ring),mean,na.rm=TRUE))
summary(an.ring)

#annual mean & SE
#meltdataset
an.ml<-melt(an.ring,id="ring")
summary(an.ml)
an.mean<-summaryBy(value~ring,FUN=c(mean,function(x) ci(x)[4],length),
                   fun.names=c("mean","SE","Sample_size"),data=an.ml)
an.mean
names(an.mean)[1:3]<-c("ring","mean","se")
#change unit from fraction to %
an.mean$mean<-an.mean$mean*100
an.mean$se<-an.mean$se*100
#save
save(an.mean,file="output/an.mean.Rdata")