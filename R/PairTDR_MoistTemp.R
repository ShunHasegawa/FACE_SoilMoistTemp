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
p <- ggplot(PairTDR_MoistTemp, 
            aes(x = Temp_Max, y = Moist, col = ring))
p <- ggplot(PairTDR_MoistTemp, 
            aes(x = Temp_Mean, y = Moist, col = ring))
p <- ggplot(PairTDR_MoistTemp, 
            aes(x = Temp_Min, y = Moist, col = ring))

p + geom_point(alpha = .3) + facet_wrap(~ring) +
  stat_ellipse(geom = "polygon", alpha = 0.1, level=0.75, 
               aes_string(col = "ring", fill = "ring"))

