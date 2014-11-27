FgMstTmpRn <- function(startDate = NULL, endDate = NULL){
  #######################
  ### Plot all dates ####
  #######################
  # load("output//Data/FACE_SoilAllProb.RData")
  
  #############
  # temp mean #
  #############
  tempDF <- subsetD(data.frame(soilRngSmry), grepl("TDRTemp", variable))
  DayTemp <- ddply(tempDF, .(Date), summarise, Mean = mean(Mean, na.rm = TRUE), 
                   Min = mean(Min, na.rm = TRUE), 
                   Max = mean(Max, na.rm = TRUE))
  DayTemp$variable <- "atop(Soil~temperature, at~15~cm~(degree~C))"
  
  
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
  co.means$variable <- "atop(Soil~moisture, at~15~cm*~('%'))"
  
  ####################
  # Blank data frame #
  ####################
  variables <- sapply(list(DayTemp, co.means, allrain), function(x) unique(x$variable))
  
  # This is gaoing to be the base of the 3 figs
  blankDF <- data.frame(Date = as.Date("2013-01-01"), 
                        Mean = c(median(DayTemp$Mean), 
                                 median(co.means$moist),
                                 median(allrain$Rain_mm_Tot)),
                        variable = variables
                        )
  blankDF$variable <- factor(blankDF$variable, levels = variables)
  ########
  # plot #
  ########
  theme_set(theme_bw())
  p <- ggplot(blankDF, aes(x =  Date, y = Mean))
  
  p2 <- p +
    geom_rect(xmin = -Inf, xmax = as.numeric(as.Date("2012-09-18")),
              ymin = -Inf, ymax = Inf, 
              fill = "grey80", col = "grey80") +
    geom_ribbon(aes(x = Date, ymin = Min, ymax = Max), fill = "firebrick1", alpha = 0.5,
                        data = DayTemp) +
    geom_line(aes(x = Date, y = Mean), size = .5, col = "firebrick1", data = DayTemp) +
    geom_line(aes(x = Date, y = moist, col = co2), data = co.means) +
    scale_color_manual(values = c("blue", "red"), expression(CO[2]~treat), 
                       labels = c("Ambient", expression(eCO[2]))) +
    geom_bar(aes(x = Date, y = Rain_mm_Tot), stat = "identity", data = allrain) +
    facet_grid(variable~. , scale = "free", labeller = label_parsed) +
    labs(x = NULL, y = NULL) +
    scale_x_date(breaks= date_breaks("2 month"),
                 labels = date_format("%b-%y"),
                 limits = c(startDate, endDate)) +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          axis.text.x = element_text(angle=45, vjust= 1, hjust = 1, 
                                     size = 13),
          legend.position = "non",
          axis.title.y = element_text(size = 15),
          plot.title = element_text(size = 25, face = "bold"))
  ggsavePP(filename= "output//Figs/GSBI_Poster/FACE_TempMoistRain", plot = p2, width = 6, height = 5)
}
