wrmDay <- c(seq(as.Date("2012-09-18"), as.Date("2013-02-28"), by = "day"),
            seq(as.Date("2013-09-18"), as.Date("2014-02-28"), by = "day"))

############
# Ringfall #
############
load("output/Data/DailyRain.RData")
summary(DailyRain)

DailyRain$month <- months(DailyRain$Date, abbreviate=TRUE)
DailyRain$year <- factor(ifelse(DailyRain$Date <= as.Date("2013-05-01"), 
                                2012, 2013))
DailyRain$variable <- "Precipitation (mm)"

## Rainy days
SmmrDF <- subsetD(DailyRain, Date %in% wrmDay)
ddply(SmmrDF, .(year), summarise, RainyDay = sum(Rain_mm_Tot > 0))

############
# Moisture #
############
load("output/Data/co.means.RData")
summary(co.means)
mistDF <- ddply(co.means, .(Date), summarise, moist = mean(moist, na.rm = TRUE) * 100)
mistDF$month <- months(mistDF$Date, abbreviate=TRUE)
mistDF$year <- factor(ifelse(mistDF$Date <= as.Date("2013-05-01"), 
                             2012, 2013))
mistDF$variable <- "Soil moisture (%)"

## Days when soil moisture is less than 5% in summer
SmmrDF <- subsetD(mistDF, Date %in% wrmDay)
ddply(SmmrDF, .(year), summarise, DryDay = sum(moist < 5))

########
# Plot #
########
hlineDF <- data.frame(z = 5, variable = "Soil moisture (%)")
theme_set(theme_bw())
p <- ggplot(subsetD(mistDF, Date %in% wrmDay), 
            aes(x =  Date, y = moist))
p2 <- p + geom_line() +
  geom_bar(aes(x = Date, y = Rain_mm_Tot), stat = "identity", 
           data = subsetD(DailyRain, Date %in% wrmDay)) +
  facet_grid(variable~year, scale = "free") +
  labs(x = "Warmer months", y = NULL) +
  geom_hline(aes(yintercept = z), data = hlineDF, linetype = "dashed")

ggsavePP(filename = "output//Figs/FACE_Summer_RainMoist",plot = p2, width = 6, height = 6)
