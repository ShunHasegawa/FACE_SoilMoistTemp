############
## ggplot ##
############
source("R/ggpl_MstTmpRn.R")
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
