rm(list=ls(all=TRUE))
#install the devtools package, which is required to install the HIEv package if necessary
#source("functions/hivs.R")

#library
source("functions/list_library.R")
library(devtools)
library(HIEv)
(.packages()) #list of packages attached
#####

#download & process soil data
source("functions/download&process_data.R")
  #load("output/allsoil.Rdata") #When you still want to run the following codes even though all files are up to date.

#produce daily ring and treatment mean
source("functions/ring&treatment_mean.R")

#produce annual moisture mean
source("functions/AnnualRingMoist_mean.R")

#download & process Rain data
source("functions/FACE_Rain.R")
  #load("output/allrain.Rdata")

#figs

#annual soil moisture mean in each ring
source("functions/FACE.annual.soil.moisture_mean.pdf.R")

#moist & temp in each ring
#file name with the used month & year
#png
source("functions/Fig_soil.moist.temp.ring.png.R")

#only moisture

#read function to produce graphs
source("functions/moist_graph.png.R")

#at 5 cm
  #png
  source("functions/soil_moisture_at_5cm.png.R")
  
  #pdf
  source("functions/soil_moisture_at_5cm.pdf.R")

#at deep layers
source("functions/FACE.Soil.moist_Deep_ring.R")

#moisture at co2 treatments and rainfall
#combine soil and rainfall data
co.rain_means <- merge(co.means,allrain,by="Date",all=TRUE)

  #pdf
    source("functions/FACE.most.temp.co2.pdf.R")
    
  #png
    source("functions/FACE.most.temp.co2.png.R")
  