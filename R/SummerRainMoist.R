############
# Ringfall #
############
load("output/Data/DailyRain.RData")
summary(DailyRain)

DailyRain$month <- months(DailyRain$Date, abbreviate=TRUE)
DailyRain$year <- factor(ifelse(DailyRain$Date <= as.Date("2013-05-01"), 
                                "Summer in 2012", "Summer in 2013"))
DailyRain$variable <- "Precipitation (mm)"

## Rainy days
SmmrDF <- subsetD(DailyRain, month %in% c("Oct", "Nov", "Dec", "Jan", "Feb"))
ddply(SmmrDF, .(year), summarise, RainyDay = sum(Rain_mm_Tot > 0))

############
# Moisture #
############
load("output/Data/co.means.RData")
summary(co.means)
mistDF <- ddply(co.means, .(Date), summarise, moist = mean(moist, na.rm = TRUE) * 100)
mistDF$month <- months(mistDF$Date, abbreviate=TRUE)
mistDF$year <- factor(ifelse(mistDF$Date <= as.Date("2013-05-01"), 
                             "Summer in 2012", "Summer in 2013"))
mistDF$variable <- "Soil moisture (%)"

## Days when soil moisture is less than 5% in summer
SmmrDF <- subsetD(mistDF, month %in% c("Oct", "Nov", "Dec", "Jan", "Feb"))
ddply(SmmrDF, .(year), summarise, DryDay = sum(moist < 5))

########
# Plot #
########
hlineDF <- data.frame(z = 5, variable = "Soil moisture (%)")
theme_set(theme_bw())
p <- ggplot(subsetD(mistDF, month %in% c("Oct", "Nov", "Dec", "Jan", "Feb")), 
            aes(x =  Date, y = moist))
p2 <- p + geom_line() +
  geom_bar(aes(x = Date, y = Rain_mm_Tot), stat = "identity", 
           data = subsetD(DailyRain, month %in% c("Oct", "Nov", "Dec", "Jan", "Feb"))) +
  facet_grid(variable~year, scale = "free") +
  labs(x = "Month", y = NULL) +
  geom_hline(aes(yintercept = z), data = hlineDF, linetype = "dashed")

ggsavePP(filename = "output//Figs/FACE_Summer_RainMoist",plot = p2, width = 6, height = 6)
