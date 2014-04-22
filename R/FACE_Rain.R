#rm(list=ls(all=TRUE))
#library to download files from HIVe
#library(devtools)
#library(HIEv)

#library
#source("functions/list_library.R")
#(.packages()) 


setToken("wSoiD4s3UDMzxwdNhzmG ")

##download up to date files from HIEv
##files <- searchHIEv(filename="FACELawn_FACE_Rain")
##files to be newly downloaded
##newfiles <- files$filename[files$file_size > file.info(files$filename)["size"]|
##                             !file.exists(files$filename)]
##files$file_size: file size on HIEv
##file.info(files$filename[i])["size"]: file size in the folder (already downloaded before)
##file.exists: if files on HIEv have been downloaded

#download, process and combine
rains <- downloadTOA5("FACELawn_FACE_Rain",cachefile="hievdata/FACE_Rain_tmp.RData",topath="hievdata/row_data")


#summary(rains)

#reorder accoding to DateTime
rains <- rains[order(rains$DateTime),]

# remove duplicates
rains <- rains[!duplicated(rains),]

# save
save(rains,file="rains.Rdata")

#write.csv(rainsn,"output/FACE_Rain(15min).csv")

#daily accumulative rainfall
DailyRain <- ddply(rains, .(Date), function(x) colSums(x[c("Rain_mm_Tot", "Through_Tot")], na.rm = TRUE))

#save
save(DailyRain,file="output/DailyRain.Rdata")

#write.csv(rain.d,"output/FACE_Rain(daily).csv")
#plot(Rain_mm_Tot~Date,type="h",data=DailyRain)

#combine with previous datasets
#call it
load("output/Rainbefore.Rdata")
#summary(Rainbefore)

#check if rainfall data match between HIEv and Vinol's file
  #remove 0
#  nr <- subset(Rainbefore,Rainbefore$Rain_mm_Tot!=0)
#  plot(Rain_mm_Tot~Date,data=nr,type="p")
  
#  dr <- subset(DailyRain,DailyRain$Rain_mm_Tot!=0)
#  points(Rain_mm_Tot~Date,data=dr,type="p",col="red")
#  dr$Rain_mm_Tot[dr$Date==as.Date("2013-06-03")]
#  #2013-06-03
#  #HIEv: rainfall = 0
#  #Vinol's file: rainfall = 20.5
#  #I use vinol's file this time for the data on this data.
#  #delete 2013-06-03 measurement from DailyRain
#  DailyRain <- DailyRain[-which(DailyRain$Date=="2013-06-03"),]

#combine
#summary(DailyRain)
  #Measurements have begun on 2013-06-03

#extract data between 2012-09-20 to 2013-06-03 from Vinol's data (Rainbefore)
before <- subset(Rainbefore,Date>="2012-09-20"&Date<"2013-06-04")
#summary(before)

allrain <- rbind.fill(before,DailyRain) #the number of columes is different so use rbind.fill rather than rbind

save(allrain,file="output/allrain.Rdata")
