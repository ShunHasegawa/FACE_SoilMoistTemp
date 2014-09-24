# load lysimeter data to plot the sampling date
load("Data//FACE_lysimeter.Rdata")
lysday <- data.frame(Date = unique(lys$date), 
                     variable = "Soil~moisture*~('%')",
                     Rain_mm_Tot = 20)



FgMstTmpRn <- function(startDate = NULL, endDate = NULL){
  #######################
  ### Plot all dates ####
  #######################
  # load("output//Data/FACE_SoilAllProb.RData")
  
  #############
  # temp mean #
  #############
  tempDF <- subsetD(soilRngSmry, grepl("TDRTemp", variable))
  DayTemp <- ddply(tempDF, .(Date), summarise, Mean = mean(Mean, na.rm = TRUE), 
                   Min = mean(Min, na.rm = TRUE), 
                   Max = mean(Max, na.rm = TRUE))
  DayTemp$variable <- "atop(Soil~temperature, at~10~cm~(degree~C))"
  
  
  ############
  # Rainfall #
  ############
  # load("output/Data/allrain.RData")
  allrain$variable <- "Precipitation~(mm)"
  
  ############
  # Moisture #
  ############
  # load("output/Data/co.means.RData")
  # change unit
  co.means$moist <- co.means$moist * 100
  co.means$variable <- "Soil~moisture*~('%')"
  
  ########
  # plot #
  ########
  theme_set(theme_bw())
  p <- ggplot(DayTemp, aes(x =  Date, y = Mean))
  
  p2 <- p + geom_ribbon(aes(x = Date, ymin = Min, ymax = Max), fill = "firebrick1", alpha = 0.5,
                        data = DayTemp) +
    geom_line(aes(x = Date, y = moist, col = co2), data = co.means) +
    scale_color_manual(values = c("blue", "red"), expression(CO[2]~treat), 
                       labels = c("Ambient", expression(eCO[2]))) +
    geom_bar(aes(x = Date, y = Rain_mm_Tot), stat = "identity", data = allrain) +
    facet_grid(variable~. , scale = "free", labeller = label_parsed) +
    labs(x = NULL, y = NULL) +
    scale_x_date(breaks= date_breaks("2 month"),
                 labels = date_format("%b-%y"),
                 limits = c(startDate, endDate)) +
    theme(axis.text.x  = element_text(angle=45, vjust= 1, hjust = 1)) +
    geom_vline(xintercept = as.numeric(as.Date("2012-09-18")), linetype = "dashed")+
    geom_point(aes(x = Date, y = Rain_mm_Tot), data = lysday)
  ggsavePP(filename= "output//Figs/FACE_TempMoistRain_lysimeter", plot = p2, width = 6, height = 6)
}
