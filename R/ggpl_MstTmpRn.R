FgMstTmpRn <- function(startDate = NULL, endDate = NULL, savefile = TRUE){
  #######################
  ### Plot all dates ####
  #######################
  # load("output//Data/FACE_SoilAllProb.RData")
  
  #############
  # temp mean #
  #############
  tempDF <- subsetD(data.frame(soilRngSmry), grepl("TDRTemp", variable))
  
  # daily mean
  DayTemp <- ddply(tempDF, .(Date), summarise, Mean = mean(Mean, na.rm = TRUE), 
                   Min = mean(Min, na.rm = TRUE), 
                   Max = mean(Max, na.rm = TRUE))
  DayTemp$variable <- "Soil~temperature~(degree*C)"
  
  # daily mean for each co2 treatments for fig for publicaiton
  co2Temp <- ddply(tempDF, .(Date, co2), summarise, Mean = mean(Mean, na.rm = TRUE),
                   Min = mean(Min, na.rm = TRUE), 
                   Max = mean(Max, na.rm = TRUE))
  co2Temp$variable <- "Soil~temperature~(degree*C)"
  
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
    geom_vline(xintercept = as.numeric(as.Date("2012-09-18")), linetype = "dashed")
  ggsavePP(filename= "output//Figs/FACE_TempMoistRain", plot = p2, width = 6, height = 6)

  ########################
  # Plot for publication #
  ########################
  # theme
  science_theme <- theme(panel.border = element_rect(colour = "black"),
                         panel.grid.major = element_blank(),
                         panel.grid.minor = element_blank(),
                         axis.text.x  = element_text(angle=45, vjust= 1, hjust = 1),
                         axis.ticks.length = unit(-.2, "lines"),
                         axis.ticks.margin = unit(.5, "lines"),
                         legend.position = c(.11, .93), 
                         legend.title = element_blank(),
                         legend.key = element_blank(),
                         legend.key.width = unit(1.8, "lines"))
  
  p3 <- p + 
    geom_line(aes(x = Date, y = Mean, linetype = co2, col = co2), 
              data = co2Temp, alpha = .6, size = .7) +
    geom_line(aes(x = Date, y = moist, linetype = co2, col = co2), 
              data = co.means, alpha = .6, size = .7) +
    scale_linetype_manual(values = c("solid", "twodash"), 
                          labels = c("Ambient", expression(eCO[2]))) +
    scale_color_manual(values = c("grey40", "black"), 
                       labels = c("Ambient", expression(eCO[2]))) +
    geom_bar(aes(x = Date, y = Rain_mm_Tot), stat = "identity", data = allrain) +
    facet_grid(variable~. , scale = "free", labeller = label_parsed) +
    labs(x = NULL, y = NULL) +
    scale_x_date(breaks= date_breaks("3 month"), 
                 labels = date_format("%b-%y"),
                 limits = c(startDate, endDate)) +
    science_theme +
    geom_vline(xintercept = as.numeric(as.Date("2012-09-18")), linetype = "dashed")
  if(savefile){
    ggsavePP(filename= "output//Figs/FACE_manuscript/FACE_TempMoistRain", plot = p3, 
             width = 6.65, height = 6.65)
  } else return(p3)
}

