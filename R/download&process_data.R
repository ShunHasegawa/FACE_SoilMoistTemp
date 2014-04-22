##only 1st time: process the files that are not on HIEv
#source("functions/Process_presoil.R")

#download up to date files from HIEv
setToken("wSoiD4s3UDMzxwdNhzmG ")

#download files from HIEv
#Remko's new function
#use chachefile function in download TOA5
allsoils <- downloadTOA5("SoilVars",cachefile="Data/hievdata/tmp.RData",
                      topath="Data/hievdata/row_data", maxnfiles = 100)

#old files are stored in c:/hievdata/tmp.RData
allsoil <- processData(allsoils)

# there is a REALLY weird value in VWC_1_Avg
#plot(allsoil$VWC_1_Avg)
summary(allsoil)
allsoil <- subset(allsoil,VWC_1_Avg < 1)

save(allsoil, file="output/Data/allsoil.RData")

#Note: save as binary (which is quicker to process than csv)
