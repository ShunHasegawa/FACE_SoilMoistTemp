# subset moisture data from different layers (n = 2)
moist.depths <- ring.means[ ,grep("Date$|ring|Theta", names(ring.means))]

moist.depths.mlt <- melt(moist.depths, id = c("Date", "ring"))

# fig
theme_set(theme_bw())
p <- ggplot(moist.depths.mlt, aes(x = Date, y = value, col = ring, linetype = ring))
pl <- p + geom_line(size = 1) + 
  scale_color_manual(values = palette(), "Ring", labels = paste("Ring", c(1:6),sep = "_")) +
  scale_linetype_manual(values = c("solid", "dashed", "dashed", "solid", "solid", "dashed"), 
                        "Ring", labels = paste("Ring", c(1:6),sep = "_")) +
  labs(x = "Time", y = "Soil moisture (% of volumetrtic water content) (n=2)") +
  facet_grid(variable ~. ) +
  geom_vline(xintercept = as.numeric(as.Date("2012-09-18")), linetype = "dashed")
  

ggsave(filename = "Figs/FACE.Soil.Moist.diff.layers.png", plot = pl)
ggsave(filename = "Figs/FACE.Soil.Moist.diff.layers.pdf", plot = pl)
