##################################################################
# function which processes dataset (add ring #, co2 treatments)  #
##################################################################
processData <- function(dataset) {
  #remvoe duplicate
  dataset <- dataset[!duplicated(dataset),]
  #add ring
  dataset$ring <- factor(substr(dataset$Source,7,7))
  #add co2
  dataset$co2 <- factor(ifelse(dataset$ring %in% c(1,4,5), "elev", "amb"))
  #add date
  dataset$Date <- as.Date(dataset$DateTime)
  return(dataset)
} 

##############################
# Daily Ring, Treatment mean #
##############################
colmean <- function(variable){
  a <- allsoil[, grep(variable, names(allsoil))]
  rowMeans(a, na.rm = TRUE)
}

#######################################
# function which produces mean and SE #
#######################################
an.mean.se <- function(x){
  data.frame(Mean = mean(x, na.rm = TRUE), 
             SE = ci(x, na.rm = TRUE)[4],
             N = sum(!is.na(x)))
}

#####################################################
# Plot all soil variables and store in one pdf file #
#####################################################

pltAllvar <- function(data, filetitle){
  figVar <- dlply(data, .(ring, type), function(x){
    # plto figures for all the variable
    figtitle <- paste("Ring", unique(x$ring), unique(x$type), sep = "_")
    p <- ggplot(x, aes(x = Date, y = value, col = variable))
    p + geom_point() +
      ggtitle(figtitle)
  })
  
  # savse in a sigle pdf
  pdf(file = filetitle, width = 6, height = 5, onefile=TRUE)
  l_ply(figVar, print)
  dev.off()
}

#########################
# subset and droplevels #
#########################
subsetD <- function(...){
  droplevels(subset(...))
}

##############################
# Save ggplot in PDF and PNG #
##############################
ggsavePP <- function(filename, plot, width, height){
  ggsave(filename = paste(filename, ".pdf", sep = ""), 
         plot = plot, 
         width = width, 
         height = height)
  
  ggsave(filename = paste(filename, ".png", sep = ""), 
         plot = plot, 
         width = width, 
         height = height, 
         dpi = 600)
}

#################
# draw a circle #
#################
circleFun <- function(center = c(0,0),diameter = 1, npoints = 100){
  r = diameter / 2
  tt <- seq(0,2*pi,length.out = npoints)
  xx <- center[1] + r * cos(tt)
  yy <- center[2] + r * sin(tt)
  return(data.frame(x = xx, y = yy))
}

###########################################################
# Calculated minimum distance between between IEM and TDR #
###########################################################
MinDistans <- function(ProbeDF, tdrDF){
  d1 <- (ProbeDF$Northing - tdrDF$Northing)^2
  d2 <- (ProbeDF$Easting - tdrDF$Easting)^2
  d <- d1 + d2
  # position of minimum distance
  df <- data.frame(
    ClosestTDR = tdrDF$Plot[which(d == min(d))][1],
    # when there are more than two closest TDRs, just use
    # the first one
    dis = sqrt(min(d))
  )
  return(df)
}

# calculate minimum distans for each ring
RngMinDis <- function(data){
  ProbeDF <- subset(data, Sample != "TDR")
  tdrDF <- subset(data, Sample == "TDR")
  ddply(ProbeDF, .(Plot, Sample), function(x) MinDistans(ProbeDF = x, tdrDF = tdrDF))
}

#############################################
# Plot distribution of soil moisture & temp #
#############################################
PltSoilVarDistr <- function(vars){
  data <- subset(TDR_CorVal, type == vars)
  p <- ggplot(data, aes(x = Easting, y = Northing))
  pl <- p + geom_point(aes(col = Mean), size = 3) +
    scale_colour_gradient("Mean", low = "blue", high = "red") +
    geom_path(aes(x = x, y = y), data = CclDF) +
    facet_wrap(~ Ring) +
    ggtitle(vars)
}
