#download up to date files from HIEv
setToken("wSoiD4s3UDMzxwdNhzmG")

#download files from HIEv
#Remko's new function
#use chachefile function in download TOA5
allsoils <- downloadTOA5("SoilVars",cachefile="Data/hievdata/tmp.RData",
                      topath="Data/hievdata/row_data", maxnfiles = 100)

#old files are stored in c:/hievdata/tmp.RData
allsoil <- processData(allsoils)

# # There are some weird values so remove
# # Data is too husge to plot all so make daily summary
# vars <- names(allsoil)[grep("Avg", names(allsoil))]
# DaySoil <- ddply(allsoil, .(Date, ring), function(x) colMeans(x[, vars], na.rm = TRUE))
# DaySoilMlt <- melt(DaySoil, id = c("Date", "ring"))
# 
# # add type column
# a <- DaySoilMlt$variable
# DaySoilMlt$type  <- gsub("_.*", "", a )
# 
# # plot
# theme_set(theme_bw())
# pltAllvar(data = DaySoilMlt, filetitle = "output//Figs//AllSoilVars.pdf")

# there is a REALLY weird value in VWC_1_Avg
#plot(allsoil$VWC_1_Avg)
summary(allsoil$VWC_1_Avg)
summary(allsoil$VWC_2_Avg)
allsoil <- subset(allsoil,VWC_1_Avg < 1)

################################################
# temporaly process, NOTE: need to check again #
# I just do it quickly this time.              #
################################################
# most of the probes are not working properly 
# in the 1-2nd weeks

# remove all data till till August for the time being
allsoil <- subset(allsoil, Date >= as.Date("2012-08-01"))

# ring2_Theta30_2_Avg is not working at all..
allsoil$Theta30_2_Avg[allsoil$ring == 2] <- NA

save(allsoil, file="output/Data/allsoil.RData")

#Note: save as binary (which is quicker to process than csv)

##########################################
# Daily min, max and mean for each probe #
##########################################
names(allsoil)

# not probe variables
Notprbs <- c("DateTime", "RECORD", "Date", "Source", "ring", "co2")

soilMlt <- melt(allsoil, id = Notprbs)

soilRngSmry <- soilMlt %.% 
  group_by(Date, ring, co2, variable) %.%
  summarise(Mean = mean(value, na.rm = TRUE),
            Min = min(value, na.rm = TRUE),
            Max = max(value, na.rm = TRUE))

# remove NA
soilRngSmry <- soilRngSmry[complete.cases(soilRngSmry), ]

# save
save(soilRngSmry, file = "output/Data/FACE_SoilAllProb.RData")

