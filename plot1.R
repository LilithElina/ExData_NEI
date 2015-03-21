## Load libraries
library(plyr)

## Read in the RDS files from current working directory
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Calculate total emissions per year
total <- ddply(NEI, .(year), function(x) sum(x$Emissions))
colnames(total) <- c("Year", "Emissions")

## Plot totals in a PNG
png("plots/plot1.png", width=480, height=480, units="px")
barplot(height=total$Emissions, names.arg=total$Year,
     xlab="Year", ylab="Total Emissions", main="Total Emissions From PM2.5")
dev.off()