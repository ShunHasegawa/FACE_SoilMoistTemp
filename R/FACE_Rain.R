# set token if you haven't done so yet
# setToken(tokenfile = "Data//token.txt")

# download, process and combine
rains <- downloadTOA5("FACELawn_FACE_Rain", cachefile = "Data/hievdata/FACE_Rain_tmp.RData", 
                      topath = "Data/hievdata/row_data")

# remove duplicates
rains <- rains[!duplicated(rains),]

# save
save(rains,file="output//Data/rains.RData")

# daily accumulative rainfall
DailyRain <- ddply(rains, .(Date), function(x) colSums(x[c("Rain_mm_Tot", "Through_Tot")], na.rm = TRUE))

# save
save(DailyRain, file="output/Data/DailyRain.RData")

##############################################################
# Combine with rainfall data measureed before september 2012 #
##############################################################

# Call data
load("output/Data/Rainbefore.Rdata")

# check if rainfall data match between HIEv and Vinol's file

# remove 0
RB <- subset(Rainbefore,Rainbefore$Rain_mm_Tot!=0)
Rhiv <- subset(DailyRain,DailyRain$Rain_mm_Tot!=0)

# plot
plot(Rain_mm_Tot ~ Date,data=RB, type="p")
points(Rain_mm_Tot~Date, data=Rhiv, type="p", col="red")
  # They are pretty much the same, so just use Rainbefore for not overwrapped
  # periods (i.e. before 2012-09-03)

# rain data between 2012-06-01 and 2012-9-3
rbDF <- subset(Rainbefore, Date < as.Date("2012-09-03") & Date > as.Date("2012-06-01"))

# Combind
allrain <- rbind.fill(rbDF, DailyRain) 
# the number of columes is different so use rbind.fill rather than rbind

plot(Rain_mm_Tot ~ Date, data = allrain, type = "h")

# save
save(allrain,file="output/Data/allrain.RData")
