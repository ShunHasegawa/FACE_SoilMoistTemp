#Daily Ring, Treatment mean
colmean <- function(variable){
  a <- allsoil[, grep(variable, names(allsoil))]
  apply(a, 1, mean, na.rm = TRUE)
}

typ <- c("Theta5", "Theta30", "ThetaHL", "Theta75", "VWC", "EC", "TDRTemp", 
          "T5", "T10", "T20", "T30", "T50", "T100")

type.mean <- cbind(allsoil[c("Date", "ring", "co2")],sapply(typ, colmean))

ring.means <- ddply(type.mean, .(Date, ring, co2), 
                   function(x) apply(x[ ,-1:-3], 2, mean, na.rm = TRUE))

names(ring.means)[c(8, 10)] <- c("moist", "temp")
ring.means<-ring.means[order(ring.means$Date),]

co.means <- ddply(ring.means, .(Date, co2), 
                   function(x) apply(x[,-1:-3], 2, mean, na.rm = TRUE)) 

save(co.means,file="output/co.means.Rdata")
