############
## ggplot ##
############
source("R/ggpl_MstTmpRn.R")
FgMstTmpRn(startDate = as.Date("2012-6-15"), endDate = as.Date("2014-3-29"))
# if you want the graph covering all period just type: FgMstTmpRn()

# Add figure caption
p <- FgMstTmpRn(startDate = as.Date("2012-6-15"), endDate = as.Date("2014-3-29"), save = FALSE)

string1 <- expression(atop(
  paste(bold("Figure S1."),  " Soil moisture and temperature (5-25 cm), and precipitation during the study period."), 
  paste("The vertical dotted line indicates when ", CO[2], " treatments were switched on (", 18^'th'~September~2012, ")."))
  )

text1 <- textGrob(string1, just = c("left", "centre"), 
                  hjust = -.05, x = 0, y = unit(1.8, "line"),
                  gp = gpar(fontsize = 10))

p2 <- arrangeGrob(p, text1, ncol = 1, nrow = 2, 
                  heights = unit(c(7, .5), "inches"))
ggsavePP(filename = "output//Figs/FACE_manuscript/FACE_TempMoistRain_caption", 
         plot = p2, width = 6.65, height = 7.7)

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
