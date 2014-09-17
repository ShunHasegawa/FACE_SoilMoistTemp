# annual ring mean moisture

# extract soil moisture data
soil.mo <- allsoil[,grep("VWC|ring|Date$|co2",names(allsoil))]

an.ring.mean <- ddply(soil.mo, .(ring, co2), 
                      function(x) colMeans(x[, 1:8]*100, na.rm = TRUE))

an.mean.se <- apply(an.ring.mean[, 3:10], 1, an.mean.se)
an.mean <- cbind(ring = factor(c(1:6)), rbind.fill(an.mean.se))

#save
save(an.mean,file="output/Data/an.mean.RData")
