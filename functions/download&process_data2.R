#download up to date files from HIEv
setToken("wSoiD4s3UDMzxwdNhzmG ")
files <- searchHIEv(filename="SoilVars")
names(files)
files$filename
file.info(files$filename)["size"]
files$file_size

downloadHIEv(files,reDownload=FALSE,maxnfiles=50)

!file.exists(files$filename)|file.info(files$filename)["size"]>files$file_size
files$file_size

#combine files
files<-dir(pattern="SoilVars") #call files with "*.dat"
files
length(files)

#make function which  processes data
redata<-function(dataset){
  ex<-dataset[c(-1,-2),]
  nums<-names(ex)[3:ncol(ex)] #factors to be numeric
  ex[nums]<-apply(ex[nums],2,as.numeric) #make them numeric
  ex$TIMESTAMP<-ymd_hms(as.character(ex$TIMESTAMP),locale="English") #reformat time
  return(ex)
}

#make a list containing all the processed dataset
soil<-NULL
for (i in 1:length(files)){
  a<-read.csv(files[i],skip=1) #1st row is removed
  a<-redata(a) #process data
  a$ring<-as.factor(rep(substr(files[i],7,7),nrow(a))) #add ring number
  soil[[i]]<-a #store new data set into a list calles "soil"
}

#all files are processed and stored in list "soil" now

#combine all the datasets
soil.va<-do.call(rbind,soil) #number of column is different as some files have VW_Avg.4., so use "rbind.fill"
head(soil.va)
some(soil.va)
summary(soil.va)

#remove duplicate
new.soil <-soil.va[!duplicated(soil.va),] 
#plot(new.soil$TIMESTAMP,col=new.soil$ring)

#treat time as date
new.soil$TIMESTAMP <-as.Date(as.character(new.soil$TIMESTAMP),"%Y-%m-%d") 

#att co2 treatment
new.soil$co2<-factor(ifelse(new.soil$ring %in% c(1,4,5), "elev", "amb"))

write.table(new.soil,"output/soil_vars(summary).csv",sep=",") ##save sumamry table as csv file

#####Make daily summary table###
names(new.soil) #column names

#VWC is soil moisture data, TDRTemp is soil temperature data

#extract soil moisture data
#combine TIMESTAMP, Rind and columns that begin with "VWC"
soil.mo.mean<-new.soil[,grep("VWC|ring|TIMESTAMP|co2",names(new.soil))] #| = or

#####
#annual ring mean moisture
#####
head(soil.mo.mean)
summary(soil.mo.mean)

#annual ring mean
vals<-names(soil.mo.mean)[grep("VWC",names(soil.mo.mean))]
an.ring<-with(soil.mo.mean,aggregate(soil.mo.mean[vals],list(ring=ring),mean,na.rm=TRUE))
summary(an.ring)
#annual mean & SE
#meltdataset
an.ml<-melt(an.ring,id="ring")
summary(an.ml)
an.mean<-summaryBy(value~ring,FUN=c(mean,function(x) ci(x)[4],length),
                   fun.names=c("mean","SE","Sample_size"),data=an.ml)
an.mean
names(an.mean)[1:3]<-c("ring","mean","se")
an.mean$mean<-an.mean$mean*100
an.mean$se<-an.mean$se*100

#combine temp and moist in the ring level
#####

#extract soil temperature data
#combine TIMESTAMP, Rind and columns that begin with "TDRTemp"
soil.temp.mean<-new.soil[,grep("TDRTemp|ring|TIMESTAMP|co2",names(new.soil))] #| = or
some(soil.temp.mean)

#re-structure dataset
#moist
so.mo<-melt(soil.mo.mean,id=c("TIMESTAMP","ring","co2")) #put all soil moisture data into one column accoding to TIMESTANP, ring and co2
some(so.mo)
mo.ring<-with(so.mo,aggregate(value,list(TIMESTAMP=TIMESTAMP,ring=ring,co2=co2),mean)) #ring mean for each measurment time (n=8)
names(mo.ring)  
names(mo.ring)[4]<-"moist" #rename the 4th column

#temp
so.temp<-melt(soil.temp.mean,id=c("TIMESTAMP","ring","co2")) #put all soil temp data into one column accoding to TIMESTANP, ring and co2
temp.ring<-with(so.temp,aggregate(value,list(TIMESTAMP=TIMESTAMP,ring=ring,co2=co2),mean)) #ring mean for each measurment time (n=8)
names(temp.ring)[4]<-"temp" #rename the 4rd column
some(temp.ring)

#combine moist (mo.ring) & temp data (temp.ring)
ring.means<-merge(mo.ring,temp.ring,by=c("TIMESTAMP","ring","co2")) #specify the common clmun by "by=".
names(ring.means)
summary(ring.means)
some(ring.means)

#re-oder the dataset accoding to date for scatter plot
ring.means<-ring.means[order(ring.means$TIMESTAMP),]
write.table(ring.means,"output/Daily.soil_vars.ring.csv",sep=",") #save table

#co2 treatment mean
co.means<-with(ring.means,aggregate(ring.means[,c("moist","temp")],list(TIMESTAMP=TIMESTAMP,co2=co2),mean))
names(co.means)
write.table(co.means,"output/Daily.soil_vars.co2.csv",sep=",") #save table
