#######################
### Plot all dates ####
#######################
load("output//Data/FACE_SoilAllProb.RData")

#############
# temp mean #
#############
tempDF <- subsetD(soilRngSmry, grepl("TDRTemp", variable))
DayTemp <- ddply(tempDF, .(Date), summarise, Mean = mean(Mean, na.rm = TRUE), 
                 Min = mean(Min, na.rm = TRUE), 
                 Max = mean(Max, na.rm = TRUE))
DayTemp$variable <- "atop(Soil~temperature, at~10~cm~(degree~C))"


############
# Ringfall #
############
load("output/Data/DailyRain.RData")
summary(DailyRain)

DailyRain$variable <- "Precipitation (mm)"

############
# Moisture #
############
load("output/Data/co.means.RData")
summary(co.means)
co.means$variable <- "Soil~moisture*~('%')"

########
# plot #
########
theme_set(theme_bw())
p <- ggplot(DayTemp, aes(x =  Date, y = Mean))

p2 <- p + geom_ribbon(aes(x = Date, ymin = Min, ymax = Max), fill = "firebrick1", alpha = 0.5,
                      data = DayTemp) +
  geom_line(aes(x = Date, y = moist, col = co2), data = co.means) +
  scale_color_manual(values = c("blue", "red"), expression(CO[2]~tret), 
                     labels = c("Ambient", expression(eCO[2]))) +
  geom_bar(aes(x = Date, y = Rain_mm_Tot), stat = "identity", data = DailyRain) +
  facet_grid(variable~. , scale = "free", labeller = label_parsed) +
  labs(x = NULL, y = NULL) +
  scale_x_date(breaks= date_breaks("2 month"),
               labels = date_format("%b-%y"),
               limits = as.Date(c("2012-7-1", "2014-4-2"))) +
  theme(axis.text.x  = element_text(angle=45, vjust= 1, hjust = 1)) +
  geom_vline(xintercept = as.numeric(as.Date("2012-09-18")), linetype = "dashed")
p2
ggsavePP(filename= "output//Figs/FACE_TempMoistRain", plot = p2, width = 6, height = 6)
