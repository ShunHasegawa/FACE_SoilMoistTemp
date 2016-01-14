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

########################
# Plot sampling scheme #
########################
SSdd <- read.csv("Data/FACESamplingScheme.csv", header = TRUE)

SSdd <- within(SSdd, {
  date <- as.Date(dmy(date))
  type <- factor("Sampling scheme")
  variable <- factor(variable, 
                     levels = c("Soil pH", "Enzymes", "Mineralisation", "Soil solution", "Soil", "IEM"))
  })


p <- ggplot(SSdd, aes(x = date, y = variable))
p2 <- p + 
  geom_point(size = 4, aes(shape = variable)) +
  scale_x_date(breaks= date_breaks("3 month"), 
               labels = date_format("%b-%y"),
               limits = c(as.Date("2012-6-15"), as.Date("2014-3-29"))) +
  science_theme +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        panel.grid.major =  element_line(colour = "grey70", size = 0.2),
        panel.grid.major.x =  element_blank(),
        legend.position = "none") +
  geom_vline(xintercept = as.numeric(as.Date("2012-09-18")), linetype = "dashed") +
  facet_grid(type~.) +
  labs(x = NULL, y = NULL)
p2

p <- FgMstTmpRn(startDate = as.Date("2012-6-15"), endDate = as.Date("2014-3-29"), save = FALSE)

p4 <- p + theme(plot.margin = unit(c(0.01, .6, .4, 2), "cm"), 
                legend.background = element_rect(fill = "transparent", colour = NA))

SSplot <- p2 + theme(plot.margin = unit(c(0.2, .7, 0, .28), "cm"))
p3 <- arrangeGrob(SSplot, p4, 
                  ncol = 1, nrow = 2, 
                  heights = unit(c(1.5, 6), "inches"))
p3
ggsavePP(p3, filename = "output/Figs/FACE_manuscript/FACE_TempMoistRain_Sampling", 
         width = 6.65, height = 7.5)
