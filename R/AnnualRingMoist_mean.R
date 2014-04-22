# annual ring mean moisture

# extract soil moisture data
soil.mo <- allsoil[,grep("VWC|ring|Date$|co2",names(allsoil))]

an.ring.mean <- ddply(soil.mo, .(ring, co2), 
                      function(x) colMeans(x[, 1:8]*100, na.rm = TRUE))

# function which produces mean and SE
an.mean.se <- function(x){
  data.frame(Mean = mean(x, na.rm = TRUE), 
             SE = ci(x, na.rm = TRUE)[4],
             N = sum(!is.na(x)))
}

an.mean.se <- apply(an.ring.mean[, 3:10], 1, an.mean.se)
an.mean <- cbind(ring = factor(c(1:6)), rbind.fill(an.mean.se))

#save
save(an.mean,file="output/an.mean.Rdata")
