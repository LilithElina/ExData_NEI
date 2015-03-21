## Load libraries
library(plyr)

## Read in the RDS files from current working directory
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Extract data for Baltimore City only
Baltimore <- subset(NEI, fips == "24510")

## Calculate total emissions per year
Balt_total <- ddply(Baltimore, .(year), function(x) sum(x$Emissions))
colnames(Balt_total) <- c("Year", "Emissions")

## Plot totals in a PNG
png("plots/plot2.png", width=480, height=480, units="px")
barplot(height=Balt_total$Emissions, names.arg=Balt_total$Year,
        xlab="Year", ylab="Total Emissions", main="Total Emissions From PM2.5 In Baltimore City")
dev.off()