# load("output//Data//FACE_SoilAllProb.RData")

# subet TDR
TDR <- subsetD(soilRngSmry, grepl("TDR|VWC", variable))

# tdr number, type, change col name of variable to dcast
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
PairTDR_MoistTemp <- dcast(TDRmlt_RmMoist_MinMax,
                          Date + ring + co2 + tdr ~ type + variable)
names(PairTDR_MoistTemp)[grep("Moist", names(PairTDR_MoistTemp))] <- "Moist"


#######
# Fig #
#######

## Moist vs Temp
theme_set(theme_bw())

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

## Plot moisture against each plot
RngMoistMean <- ddply(PairTDR_MoistTemp, .(Date, ring), summarise, value = mean(Moist, na.rm = TRUE)) 
RngMoist <- dcast(RngMoistMean, Date ~ ring)
names(RngMoist)[-1] <- paste("Ring_", names(RngMoist)[-1], sep = "")
scatterplotMatrix(~ Ring_1 + Ring_2 + Ring_3 + Ring_4 + Ring_5 + Ring_6, 
                  data = RngMoist, 
                  diag = "boxplot",
                  lwd = 2,
                  smoother = FALSE)
