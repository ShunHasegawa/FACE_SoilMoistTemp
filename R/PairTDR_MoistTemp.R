load("output//Data//FACE_SoilAllProb.RData")

# subet TDR
TDR <- subsetD(soilRngSmry, grepl("TDR|VWC", variable))

# tdr number, type, change col name of variable to cast
TDR <- within(TDR, {
  tdr <- factor(str_sub(variable,-5,-5))
  type <- factor(ifelse(grepl("VWC", variable), "Moist", "Temp"))
})
names(TDR)[grep("variable", names(TDR))] <- "probe"

# melt dataset
TDRmlt <- melt(TDR, id = c("Date", "ring", "co2", "probe", "tdr", "type"))

# remove min and max moist
TDRmlt_RmMoist_MinMax <- subset(TDRmlt, !(type == "Moist" & variable %in% c("Min", "Max")))
unique(TDRmlt_RmMoist_MinMax$variable:TDRmlt_RmMoist_MinMax$type)

# pair moist and temp for each tdr
PairTDR_MoistTemp <- cast(TDRmlt_RmMoist_MinMax,
                          Date + ring + co2 + tdr ~ type + variable)
names(PairTDR_MoistTemp)[grep("Moist", names(PairTDR_MoistTemp))] <- "Moist"


#######
# Fig #
#######

PltMoistTemp <- function(data, x, size = 1){
  p <- ggplot(data, aes_string(x = x, y = "log(Moist)", col = "ring"))
  p2 <- p + geom_point(size = size, alpha = .3) +
    guides(color = guide_legend(override.aes = list(size = 2)))
  p2
}

temps <- names(PairTDR_MoistTemp)[grep("Temp", names(PairTDR_MoistTemp))]

# for each ring
l_ply(temps, function(x) 
  ggsavePP(filename = paste("output//Figs/FACE_Ring_Moist_", x, sep = ""),
           plot = PltMoistTemp(data = PairTDR_MoistTemp, x , size = .5) + 
             facet_wrap(~ring), 
           width = 6, height = 4))

# single fig
l_ply(temps, function(x) 
  ggsavePP(filename = paste("output//Figs/FACE_Moist_", x, sep = ""),
           plot = PltMoistTemp(data = PairTDR_MoistTemp, x , size = .5), 
           width = 6, height = 4))
