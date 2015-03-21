## Load libraries
library(plyr)
library(ggplot2)
library(grid)
library(gridExtra)

## Read in the RDS files from current working directory
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Find coal combustion-related sources in SCC data EI Sector
SCC_coal <- SCC[grep("Coal", SCC$EI.Sector), ]

## Filter NEI data with SCC numbers
NEI_coal <- NEI[NEI$SCC %in% SCC_coal$SCC, ]

## Calculate total emissions per year
coal_total <- ddply(NEI_coal, .(year), function(x) sum(x$Emissions))
colnames(coal_total) <- c("Year", "Emissions")

## Plot totals and a boxplot in a PNG
png("plots/plot4.png", width=960, height=480, units="px")

# First the boxplot.
# Due to extreme outliers, the scale of the y axis is set to log10,
# but this doesn't seem to be the way to go.
pb <- ggplot(NEI_coal, aes(x=factor(year), y=Emissions)) +
  geom_boxplot() + scale_y_log10() +
  xlab("Year") + ylab("Emissions (log10)")

# And now the totals as a barplot, similar to the plots before.
pt <- ggplot(coal_total, aes(x=factor(Year), y=Emissions)) +
  geom_bar(stat="identity") +
  ylab("Total Emissions") + xlab("Year")

# Combine them in one figure.
grid.arrange(pb, pt, ncol = 2,
             main = "Emissions From Coal Combustion-Related Sources")

dev.off()

## It is interesting to see how the outliers in the boxplot change from being higher
## to being higher and lower, to just being lower over time.
## This is also shown in the line plot of total emissions, which are reduced over
## the years, while median and interquartile range increase in the boxplot.