##only 1st time: process the files that are not on HIEv
#source("functions/Process_presoil.R")

#download up to date files from HIEv
setToken("wSoiD4s3UDMzxwdNhzmG ")

#download files from HIEv
#Remko's new function
#use chachefile function in download TOA5
soils <- downloadTOA5("SoilVars",cachefile="hievdata/tmp.RData",
                      topath="hievdata/row_data", maxnfiles = 100)
?downloadTOA5
#old files are stored in c:/hievdata/tmp.RData

#call presoil data
load("output/presoilData.R")

#cobine all files
allsoils <- rbind.fill(presoilData,soils)

#####
#function which processes dataset (add ring #, co2 treatments)
#####
processData <- function(dataset) {
  #remvoe duplicate
  dataset <- dataset[!duplicated(dataset),]
  #add ring
  dataset$ring <- factor(substr(dataset$Source,7,7))
  #add co2
  dataset$co2 <- factor(ifelse(dataset$ring %in% c(1,4,5), "elev", "amb"))
  #add date
  dataset$Date <- as.Date(dataset$DateTime)
  return(dataset)
} 


allsoil <- processData(allsoils)

# there is a REALLY weird value in VWC_1_Avg
#plot(allsoil$VWC_1_Avg)
summary(allsoil)

allsoil <- subset(allsoil,VWC_1_Avg < 1)


save(allsoil, file="output/allsoil.RData")

#Note: save as binary (which is quicker to process than csv)
