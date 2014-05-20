rm(list=ls(all=TRUE))
#install the devtools package, which is required to install the HIEv package if necessary
#source("functions/hivs.R")

library(devtools)
library(HIEv)
library(plyr)
library(reshape)
library(packrat)
library(ggplot2)
library(gmodels)
library(car)
library(lubridate)
library(dplyr)

source("R/functions.R")

# download & process soil data
source("R/download&process_data.R")
 #load("output/allsoil.Rdata") #When you still want to run the following codes even though all files are up to date.

#produce daily ring and treatment mean
source("R/ring&treatment_mean.R")

#produce annual moisture mean
source("R/AnnualRingMoist_mean.R")

#download & process Rain data
source("R/FACE_Rain.R")
  #load("output/allrain.Rdata")

#figs

#annual soil moisture mean in each ring
source("R/FACE.annual.soil.moisture_mean.pdf.R")

# soil moisture for each ring at different depths (n = 2)
source("R/Fig.soil.moist.dif.depths.R")

#  soil moisture at 5 cm (n = 8)
source("R/fig.soil.moist.5cm.N8.R")


#moisture at co2 treatments and rainfall
#combine soil and rainfall data
co.rain_means <- merge(co.means,allrain,by="Date",all=TRUE)

  #pdf
    source("R/FACE.moist.temp.co2.pdf.R")
    
  #png
    source("R/FACE.moist.temp.co2.png.R")
  