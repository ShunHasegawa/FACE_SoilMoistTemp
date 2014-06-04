cor <- read.csv("Data//ProbeCoordinate.csv")

corRct <- subsetD(cor, Sample %in% c("vegetation", "soil"))

# Data frame to draw a circle
CclDF <- circleFun(diameter = 25)

theme_set(theme_bw())
p <- ggplot(cor, aes(x = Easting, y = Northing))
pl <- p + geom_point(aes(shape = Sample, col = Sample), size = 1) +
  geom_rect(aes(xmin = Easting - 1, xmax = Easting + 1, 
                ymin = Northing - 1, ymax = Northing + 1, 
                fill = Sample),
            alpha = 0.5,
            data = corRct) +
  geom_path(aes(x = x, y = y), data = CclDF) +
  facet_wrap(~Ring)

ggsavePP(filename = "output//Figs/FigsFACE_Cordinates", plot = pl, width = 8, height = 4)
