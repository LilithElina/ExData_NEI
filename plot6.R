## Load libraries
library(plyr)
library(ggplot2)
library(grid)
library(gridExtra)

## Read in the RDS files from current working directory
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Find motor vehicle sources in SCC data EI Sector
SCC_vehicle <- SCC[grep("Motor|Vehicle", SCC$EI.Sector), ]

## Filter NEI data with SCC numbers
NEI_vehicle <- NEI[NEI$SCC %in% SCC_vehicle$SCC, ]

## Extract data for Baltimore City and LA County
subset_vehicle <- subset(NEI_vehicle, fips=="24510" | fips=="06037")

## Calculate total emissions per year
subset_veh_total <- ddply(subset_vehicle, .(year, fips), function(x) sum(x$Emissions))
colnames(subset_veh_total) <- c("Year", "Location", "Emissions")

## Plot totals and a boxplot in a PNG
png("plot6.png", width=960, height=480, units="px")

# Due to extreme outliers, the scale of the y axis is set to log10.
pb <- ggplot(subset_vehicle, aes(x=factor(year), y=Emissions)) +
  geom_boxplot(aes(fill=fips)) + scale_y_log10() +
  xlab("Year") +
  scale_fill_discrete(name="Location",
                      breaks=c("06037", "24510"),
                      labels=c("LA County", "Baltimore City"))

# And now the totals as a line plot, also with logarithmic scaling,
# beause there is such a huge difference between the locations.
pt <- ggplot(subset_veh_total, aes(x=Year, y=Emissions, group=Location)) +
  geom_line(aes(colour=Location)) + scale_y_log10() +
  ylab("Total Emissions") +
  scale_colour_discrete(name="Location",
                        breaks=c("06037", "24510"),
                        labels=c("LA County", "Baltimore City"))

# Combine them in one figure.
grid.arrange(pb, pt, ncol = 2,
             main = "Emissions from Motor Vehicle Sources in Baltimore City and LA County")

dev.off()