theme_set(theme_bw())
p <- ggplot(ring.means, aes(x = Date, y = moist * 100, col = ring, linetype = ring))
pl <- p + geom_line(size = 1) + 
  scale_color_manual(values = palette(), "Ring", labels = paste("Ring", c(1:6),sep = "_")) +
  scale_linetype_manual(values = c("solid", "longdash", "longdash", "solid", "solid", "longdash"), 
                        "Ring", labels = paste("Ring", c(1:6),sep = "_")) +
  scale_x_date(breaks= date_breaks("2 month"), labels = date_format("%b-%y")) +
  theme(axis.text.x  = element_text(angle=45, vjust= 1, hjust = 1)) +
  labs(x = "Time", y = "Soil moisture (% of volumetrtic water content)(n=8)") +
  geom_vline(xintercept = as.numeric(as.Date("2012-09-18")), linetype = "longdash")
  
ggsavePP(filename = "output/Figs/FACE.Soil.Moist.at.5cm", width = 8, height = 5, plot = pl)