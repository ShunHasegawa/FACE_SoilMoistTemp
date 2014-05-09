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

