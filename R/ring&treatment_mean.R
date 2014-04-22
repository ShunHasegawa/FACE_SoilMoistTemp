typ <- c("Theta5", "Theta30", "ThetaHL", "Theta75", "VWC", "EC", "TDRTemp", 
          "T5", "T10", "T20", "T30", "T50", "T100")

type.mean <- cbind(allsoil[c("Date", "ring", "co2")], sapply(typ, colmean))

ring.means <- ddply(type.mean, .(Date, ring, co2), 
                    function(x) colMeans(x[ ,-1:-3], na.rm = TRUE))

names(ring.means)[c(8, 10)] <- c("moist", "temp")

ring.means <- ring.means[order(ring.means$Date),]

save(ring.means, file = "output/Data/soil.var_ring.means.RData")

# write.csv(ring.means, file = "output/FACE.soil.var_ring.means.csv", row.names = FALSE)

co.means <- ddply(ring.means, .(Date, co2), 
                  function(x) colMeans(x[ ,-1:-3], na.rm = TRUE))

save(co.means,file="output/Data/co.means.RData")
