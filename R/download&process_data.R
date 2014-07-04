#######################################
# download up to date files from HIEv #
#######################################
setToken(tokenfile = "Data/token.txt")

# download files from HIEv
# use chachefile function in download TOA5
allsoils <- downloadTOA5("SoilVars",cachefile="Data/hievdata/tmp.RData",
                      topath="Data/hievdata/row_data", maxnfiles = 100)
#old files are stored in c:/hievdata/tmp.RData

# remove duplicates and add ring and co2 columns
allsoil <- processData(allsoils)
  # Note: this will take some time...

#################
# Cleaning data #
#################

# There are some weird values so remove so need to clean up 
# data. NOTE: need to check again I just do it quickly this
# time.

#############################################
## visually inspect by plottint all probes ##
#############################################
source("R/PlotAllProbes.R")

# there is a REALLY weird value in VWC_1_Avg
summary(allsoil$VWC_1_Avg)
summary(allsoil$VWC_2_Avg)
# VWC is soil moisture so can't be larger than 1 (or evern
# 0.4)
allsoil <- subset(allsoil,VWC_1_Avg < 1 & VWC_2_Avg <1)

# Most of the probes are not working properly in the 1-2nd 
# weeks so remove all data till till ##August## for the time
# being
allsoil <- subset(allsoil, Date >= as.Date("2012-08-01"))

# ring2_Theta30_2_Avg is not working at all..
allsoil$Theta30_2_Avg[allsoil$ring == 2] <- NA

save(allsoil, file="output/Data/allsoil.RData")
# Note: save as binary (which is quicker to process than
# csv)

##########################################
# Daily min, max and mean for each probe #
##########################################
# load("output/Data/allsoil.RData")

# not probe variables
Notprbs <- c("DateTime", "RECORD", "Date", "Source", "ring", "co2", "TrghFlow_mm_Tot")

soilMlt <- melt(allsoil, id = Notprbs)

# use dplyr as it's a lot faster than plyr
soilRngSmry <- soilMlt %.% 
  group_by(Date, ring, co2, variable) %.%
  summarise(Mean = mean(value, na.rm = TRUE),
            Min = min(value, na.rm = TRUE),
            Max = max(value, na.rm = TRUE))

# remove NA
soilRngSmry <- soilRngSmry[complete.cases(soilRngSmry), ]

# save
save(soilRngSmry, file = "output/Data/FACE_SoilAllProb.RData")

