#download up to date files from HIEv
setToken("wSoiD4s3UDMzxwdNhzmG ")
 
files <- searchHIEv(filename="SoilVars")

#files to be newly downloaded
newfiles <- files$filename[files$file_size > file.info(files$filename)["size"]|
                             !file.exists(files$filename)]
  #files$file_size: file size on HIEv
  #file.info(files$filename[i])["size"]: file size in the folder (already downloaded before)
  #file.exists: if files on HIEv have been downloaded

#####
#function which processes dataset (remove duplicates, add ring #, co2 treatments)
#####
processData <- function(dataset) {
  #remove duplicate
  d <- dataset[!duplicated(dataset),]
  #add ring
  d$ring <- factor(substr(d$Source,7,7))
  #add co2
  d$co2 <- factor(ifelse(d$ring %in% c(1,4,5), "elev", "amb"))
  return(d)
} 

#####
#function which downloads, processes and combines all files
#####
processAll <- function(){
  soils <- downloadTOA5(hievSearch=files,reDownload=FALSE)
  #these files are not on HIEv
  prefiles <- dir(pattern="20130603") 
  presoils <- lapply(prefiles,readTOA5) #make a list
  presoilData <- do.call(rbind,presoils) #combine
  soils <- rbind(soils,presoilData)
  #process dataset
  allsoil <- processData(soils)
  return(allsoil)
}

#####
#function which processes only new files
#####
processNew <- function(){
  newsoils <- downloadTOA5(filename=paste(newfiles,collapse="|"),reDownload=FALSE)
  newsoilData <- processData(newsoils) #process
  return(newsoilData)
}

#####
#first time: make a file "allsoil.Rdata", from second time: combine newly processed
#data and the previously made "allsoil.Rdata"
#####
if(file.exists("output/allsoil.RData")){
  if(length(newfiles)==0){
    stop("files are up to date, not required to update") #when there's no file to be downloaded
  } else{
    newsoilData <- processNew()
    #combine with the previously saved dataset
    load("output/allsoil.RData")
    allsoil <- rbind(allsoil,newsoilData)
  }
} else {
  allsoil <- processAll()
}

#save as binary (which is quicker to process than csv)
save(allsoil, file="output/allsoil.RData")







newsoils <- downloadTOA5(filename=newfiles,reDownload=FALSE)
list(newfiles)
newfiles

summary(newfiles)
searchHIEv(filename="FACE_R3_B1_SoilVars_20130831.dat|FACE_R3_B1_SoilVars_20131031.dat")
newfiles[2]


files <- list()
for (i in 1:length(newfiles)){
  files[[i]] <- searchHIEv(filename=newfiles[i])
}
filesds <- do.call(rbind,files)
filesds


searchHIEv()

searchHIEv(filename=newfiles)


#download files
downloadHIEv(files,reDownload=FALSE,maxnfiles=50,)

#function which  processes data
  redata<-function(dataset){
    ex<-dataset[c(-1,-2),]
    nums<-names(ex)[3:ncol(ex)] #factors to be numeric
    ex[nums]<-apply(ex[nums],2,as.numeric) #make them numeric
    ex$TIMESTAMP<-ymd_hms(ex$TIMESTAMP,locale="English") #reformat time
    return(ex)
  }

#function which put all processed files into a list and then combine all
list_files <- function(filenames){
  soil <- list()
  for (i in 1:length(filenames)){
    a<-read.csv(filenames[i],skip=1) #1st row is removed
    a<-redata(a) #process data
    a$ring<-as.factor(rep(substr(filenames[i],7,7),nrow(a))) #add ring number
    soil[[i]]<-a #store new data set into a list called "soil"
  }
  allsoil<-do.call(rbind,soil)
  return(allsoil)
}

#function which processes all files in the directory
  process_all <- function(){
    files <- dir(pattern="SoilVars")
    allsoil <- list_files(files)
    return(allsoil)
  }
  

#first time: make a file "allsoil.Rdata", from second time: combine newly processed
#data and the previously made "allsoil.Rdata"
if(file.exists("output/allsoil.RData")){
  if(length(newfiles)==0){
    stop("files are up to date") #when there's no file to be downloaded
  } else{
    newsoilds <- list_files(newfiles) #process newfiles and combine with the previously made file
    load("output/allsoil.RData")
    allsoil <- rbind(allsoil, newsoilds)
  }
} else {
  process_all()
  #combine all the datasets and save as binary (which is quicker to process than csv)
  save(allsoil, file="output/allsoil.RData")
}
  
f <- dir(pattern="SoilVars")
f
t <- readTOA5("FACE_R1_B1_SoilVars_20130603.dat")
summary(t)


  allsoil <- rbind(allsoil,newsoilds)




if(length(newfiles)==0) {
  load("output/allsoil.RData")
  soil.va <- allsoil  
} else {
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
  for (i in 1:length(newfiles)){
    a<-read.csv(newfiles[i],skip=1) #1st row is removed
    a<-redata(a) #process data
    a$ring<-as.factor(rep(substr(newfiles[i],7,7),nrow(a))) #add ring number
    soil[[i]]<-a #store new data set into a list called "soil"
    }
  #combine all the datasets
  soil.va<-do.call(rbind,soil)
  #combine with the previous dataset and savve
  if(file.exists("output/allsoil.RData")) {  #if output/allsoil.RData already exsits, comibine to it
    load("output/allsoil.RData")
    allsoil <- rbind(allsoil, soil.va)
    save(allsoil, file="output/allsoil.RData")
    } else {
      #if output/allsoil.RData have not been created yet, make it (1st one)
      allsoil <- soil.va
      save(allsoil, file="output/allsoil.RData") #RData is binary for a lot quicker to load than .csv
      }
  load("output/allsoil.RData")
  soil.va <- allsoil  
}

#see also downloadTOA5 {HIEv}
files[1]
a <- downloadTOA5(hievSearch=files)
downloadTOA5
summary(a)
unique(a$Source)
any(duplicated(a))
#filesbefore <- dir(pattern="SoilVars")
#combine files
#filesafter<-dir(pattern="SoilVars") #call files with "soilVars"
#filesafter

#newfiles <- setdiff(filesbefore,filesafter)
#newfiles


head(soil.va)
some(soil.va)
summary(soil.va)

#remove duplicate
new.soil <-soil.va[!duplicated(soil.va),] 
#plot(new.soil$TIMESTAMP,col=new.soil$ring)

#treat time as date
new.soil$TIMESTAMP <-as.Date(as.character(new.soil$TIMESTAMP),"%Y-%m-%d") 

#add co2 treatment
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
