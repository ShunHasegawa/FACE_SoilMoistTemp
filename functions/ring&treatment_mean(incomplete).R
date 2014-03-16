#Daily Ring, Treatment mean

#function which gives the ring mean of moisture and temperature
ringmean <- function(dataset){
  #VWC is soil moisture data, TDRTemp is soil temperature data
  
  #combine temp and moist in the ring level
    #extract soil moisture data
    #combine Date, Rind and columns that begin with "VWC"
    soil.mo.mean<-dataset[,grep("VWC|ring|Date$|co2",names(dataset))] 
    #| = or,$:end of the word to avoild to obtain DateTime
    
    #extract soil temperature data
    #combine Date, Rind and columns that begin with "TDRTemp"
    soil.temp.mean<-dataset[,grep("TDRTemp|ring|Date$|co2",names(dataset))] 
        
  #re-structure dataset
    #moist
    so.mo<-melt(soil.mo.mean,id=c("Date","ring","co2")) #put all soil moisture data into one column accoding to Date, ring and co2
    some(so.mo)
    mo.ring<-with(so.mo,aggregate(value,list(Date=Date,ring=ring,co2=co2),mean)) #ring mean for each measurment time (n=8)
    names(mo.ring)  
    names(mo.ring)[4]<-"moist" #rename the 4th column
    
    #temp
    so.temp<-melt(soil.temp.mean,id=c("Date","ring","co2")) #put all soil temp data into one column accoding to TIMESTANP, ring and co2
    temp.ring<-with(so.temp,aggregate(value,list(Date=Date,ring=ring,co2=co2),mean)) #ring mean for each measurment time (n=8)
    names(temp.ring)[4]<-"temp" #rename the 4rd column
    some(temp.ring)
  
  #combine moist (mo.ring) & temp data (temp.ring)
    ring.means<-merge(mo.ring,temp.ring,by=c("Date","ring","co2")) #specify the common clmun by "by=".
    names(ring.means)
    summary(ring.means)
    some(ring.means)
    
  #re-oder the dataset accoding to date for scatter plot
    ring.means<-ring.means[order(ring.means$Date),]
  return(ring.means)
}


#produce ring means and co2 means and save as binary files
if(!file.exists("output/ring.means.Rdata")) {#file doesn't exist->all the datasets need to be processed
  ring.means <- ringmean(allsoil)
  save(ring.means,file="output/ring.means.Rdata")
  co.means <- with(ring.means,aggregate(ring.means[,c("moist","temp")],list(Date=Date,co2=co2),mean))
  save(co.means,file="output/co.means.Rdata")
} else {#file exists-> process only new datasets and combine to the previous files
  ring.means_newsoil <- ringmean(newsoilData)
  load("output/ring.means.Rdata")
  ring.means <- rbind(ring.means,ring.means_newsoil)
  ring.means <- ring.means[order(ring.means$Date),]#re-order accoding to date
  ring.means <- ring.means[!duplicated(ring.means),]
  save(ring.means,file="output/ring.means.Rdata")
  #co2 treatment
  co.means_newsoil <- with(ring.means_newsoil,aggregate(ring.means_newsoil[,c("moist","temp")],
                                                        list(Date=Date,co2=co2),mean))
  load("output/co.means.Rdata")
  co.means <- rbind(co.means, co.means_newsoil)
  co.means <- co.means[order(co.means$Date),] #re-order
  co.means <- co.means[!duplicated(co.means),]#remove duplicates
  save(co.means,file="output/co.means.Rdata")
}

#write.table(co.means,"output/Daily.soil_vars.co2.csv",sep=",") #save table
