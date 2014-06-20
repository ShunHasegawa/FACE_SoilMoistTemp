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

PltMoistTemp(data = PairTDR_MoistTemp, "Temp_Mean" , size = .5) +
  facet_wrap(~ring)
box_top <- ggplot(PairTDR_MoistTemp, aes(y = "Temp_Moist")) + 
  boxplot() + coord_flip()

install.packages("boxplotdbl")
library(boxplotdbl)

dev.off()

par(mfrow = c(2,3))
d_ply(PairTDR_MoistTemp, .(ring), function(x)
  with(x, boxplotdou(cbind(ring, Temp_Mean), cbind(ring, Moist), 
                     xlim = c(5, 30), ylim = c(0, 0.5)))
  )

d_ply(PairTDR_MoistTemp, .(ring), function(x)
  with(x, boxplotdou(cbind(ring, Temp_Mean), cbind(ring, log(Moist)), 
                     xlim = c(5, 30)))
  )



data(iris)
head(iris)
iris[c(5,1)]

?boxplotdou


FigLst <- dlply(PairTDR_MoistTemp, .(ring), 
                function(x) scatterplot(Moist ~ Temp_Max, data = x, main = unique(x$ring)))
?scatterplot
par(mfrow = c(2,3))
FigLst[[3]]


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
