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

## Extract data for Baltimore City only
Balt_vehicle <- subset(NEI_vehicle, fips == "24510")

## Calculate total emissions per year
Balt_veh_total <- ddply(Balt_vehicle, .(year), function(x) sum(x$Emissions))
colnames(Balt_veh_total) <- c("Year", "Emissions")

## Plot totals and a boxplot in a PNG
png("plot5.png", width=960, height=480, units="px")

# Due to extreme outliers, the scale of the y axis is set to log10.
pb <- ggplot(Balt_vehicle, aes(x=factor(year), y=Emissions)) +
  geom_boxplot() + scale_y_log10() +
  xlab("Year")

# And now the totals as a line plot.
pt <- ggplot(Balt_veh_total, aes(x=Year, y=Emissions)) +
  geom_line() + ylab("Total Emissions")

# Combine them in one figure.
grid.arrange(pb, pt, ncol = 2,
             main = "Emissions from Motor Vehicle Sources in Baltimore City")

dev.off()