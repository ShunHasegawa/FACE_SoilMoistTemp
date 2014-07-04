# Plot all probes
# Data is too husge to plot all so make daily summary
vars <- names(allsoil)[grep("Avg", names(allsoil))]
DaySoil <- ddply(allsoil, .(Date, ring), function(x) colMeans(x[, vars], na.rm = TRUE))
DaySoilMlt <- melt(DaySoil, id = c("Date", "ring"))

# add type column
a <- DaySoilMlt$variable
DaySoilMlt$type  <- gsub("_.*", "", a )

# plot
theme_set(theme_bw())
pltAllvar(data = DaySoilMlt, filetitle = "output//Figs//AllSoilVars.pdf")
