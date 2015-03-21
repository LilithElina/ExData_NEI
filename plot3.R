## Load libraries
library(plyr)
library(ggplot2)

## Read in the RDS files from current working directory
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Extract data for Baltimore City only
Baltimore <- subset(NEI, fips == "24510")

## Calculate total emissions per type and year
Balt_type_total <- ddply(Baltimore, .(type, year), function(x) sum(x$Emissions))
colnames(Balt_type_total) <- c("Type", "Year", "Emissions")

## Plot totals in a PNG
png("plots/plot3.png", width=480, height=480, units="px")
p <- ggplot(Balt_type_total, aes(x=factor(Year), y=Emissions, fill=Type))
p + geom_bar(stat="identity", position="dodge") +
  ggtitle("Total Emissions From PM2.5 In Baltimore City") +
  ylab("Total Emissions")
dev.off()