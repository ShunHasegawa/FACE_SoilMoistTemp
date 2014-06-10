cor <- read.csv("Data//ProbeCoordinate.csv")

###########
# Process #
###########
# remove mineralisaation
cor <- subsetD(cor, Sample != "Mineralisation tube")
cor$Sample <- factor(cor$Sample, labels = c("IEM", "Lysimeter", "soil", "TDR", "vegetation"))

# plot cordinates
corRct <- subsetD(cor, Sample %in% c("vegetation", "soil"))

#######
# Fig #
#######
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

##########################################
# pair instrument/plot with nearest TDR  #
##########################################
MinDis <- ddply(cor, .(Ring), RngMinDis)
MinDis <- MinDis[order(MinDis$Sample), ]

# pairwise with soil variable data
load("output//Data//FACE_SoilAllProb.RData")

TDRDF <- subsetD(soilRngSmry, grepl("VWC|TDR", variable))
TDRDF$variable <- as.character(TDRDF$variable)
# get TDR number
TDRDF$tdr <- factor(str_sub(TDRDF$variable,-5,-5))

# merge
FACE_TDR_Probe <- merge(TDRDF, MinDis, by.x = c("ring", "tdr"), by.y = c("Ring","ClosestTDR"))
save(FACE_TDR_Probe, file = "output/Data/FACE_TDR_Probe.RData")

# reoganise
names(FACE_TDR_Probe)[grep("Plot", names(FACE_TDR_Probe))] <- "plot"
names(FACE_TDR_Probe)[grep("variable", names(FACE_TDR_Probe))] <- "probe"
FACE_TDR_Probe$type <- factor(ifelse(grepl("VWC",FACE_TDR_Probe$probe), "Moist", "Temp"))

FACE_TDR_Probe_Mlt <- melt(FACE_TDR_Probe, 
                           id = names(FACE_TDR_Probe)[which(!(names(FACE_TDR_Probe) %in% c("Mean", "Min", "Max")))])

FACE_TDR_ProbeDF <- cast(FACE_TDR_Probe_Mlt, Date + ring + plot + Sample ~ type + variable)

# remove moist min and max
FACE_TDR_ProbeDF <- FACE_TDR_ProbeDF[, -grep("Moist_Min|Moist_Max", names(FACE_TDR_ProbeDF))]
names(FACE_TDR_ProbeDF)[grep("Moist", names(FACE_TDR_ProbeDF))] <- "Moist"

# save
save(FACE_TDR_ProbeDF, file = "output/Data/FACE_TDR_ProbeDF.RData")
