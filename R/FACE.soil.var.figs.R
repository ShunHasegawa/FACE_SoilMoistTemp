rm(list=ls(all=TRUE))
#install the devtools package, which is required to install the HIEv package if necessary
#source("functions/hivs.R")

library(reshape)
library(plyr)
library(dplyr)
library(devtools)
library(HIEv)
library(packrat)
library(ggplot2)
library(gmodels)
library(car)
library(lubridate)
library(scales)
library(proto)

source("R/functions.R")

# download & process soil data
source("R/download&process_data.R")
# load("output/Data/allsoil.RData")
# load("output/Data/FACE_SoilAllProb.RData")

# produce daily ring and treatment mean
source("R/ring&treatment_mean.R")
# load("output/Data/soil.var_ring.means.RData")
# load("output/Data/co.means.RData")

# produce annual moisture mean
source("R/AnnualRingMoist_mean.R")
# load("output/Data/an.mean.RData")

# download & process Rain data
source("R/FACE_Rain.R")
# load("output/Data/allrain.RData")

########
# Figs #
########

############
## ggplot ##
############
source("R/Fig.R")
FgMstTmpRn(startDate = as.Date("2012-7-1"), endDate = as.Date("2014-4-2"))
# if you want the graph covering all period just type: FgMstTmpRn()

##########
## Base ##
##########
# Plot moist, rainfall, and temp on one graph

# annual soil moisture mean in each ring
source("R/FACE.annual.soil.moisture_mean.pdf.R")

# soil moisture for each ring at different depths (n = 2)
source("R/Fig.soil.moist.dif.depths.R")

#  soil moisture at 5 cm (n = 8)
source("R/fig.soil.moist.5cm.N8.R")

#moisture at co2 treatments and rainfall
#combine soil and rainfall data
co.rain_means <- merge(co.means,allrain,by="Date",all=TRUE)
source("R/FACE.moist.temp.co2.pdf.R") # pdf
source("R/FACE.moist.temp.co2.png.R") # png
  