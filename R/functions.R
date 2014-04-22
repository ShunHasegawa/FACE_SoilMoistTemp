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