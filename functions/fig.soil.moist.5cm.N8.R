theme_set(theme_bw())
p <- ggplot(ring.means, aes(x = Date, y = moist * 100, col = ring, linetype = ring))
pl <- p + geom_line(size = 1) + 
  scale_color_manual(values = palette(), "Ring", labels = paste("Ring", c(1:6),sep = "_")) +
  scale_linetype_manual(values = c("solid", "dashed", "dashed", "solid", "solid", "dashed"), 
                        "Ring", labels = paste("Ring", c(1:6),sep = "_")) +
  labs(x = "Time", y = "Soil moisture (% of volumetrtic water content)") +
  geom_vline(xintercept = as.numeric(as.Date("2012-09-18")), linetype = "dashed") +
  ggtitle("n = 8")

ggsave(filename = "Figs/FACE.Soil.Moist.at.5cm.png", width = 8, height = 4, units= "in", plot = pl)
ggsave(filename = "Figs/FACE.Soil.Moist.at.5cm.pdf", width = 8, height = 4, units= "in", plot = pl)