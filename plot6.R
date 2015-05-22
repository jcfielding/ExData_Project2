#plot6.R creates a plot to answer the following question:

#Compare emissions from motor vehicle sources in Baltimore City with emissions from motor
#vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen
#greater changes over time in motor vehicle emissions?

library(dplyr)
library(ggplot2)

#Check if files exists, and download if necessary
zip.name <- "data.zip"

if(!file.exists("summarySCC_PM25.rds") && 
     !file.exists("Source_Classification_Code.rds")) {
  
  zip.url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  setInternet2(use = TRUE)
  
  if(!file.exists(zip.name)) {
    download.file(zip.url, destfile = zip.name, method = "auto", mode = "wb")
  }
  
  #Extract the zip
  unzip(zip.name) 
}

#Read the data
data.nei <- readRDS("summarySCC_PM25.rds")        
data.scc <- readRDS("Source_Classification_Code.rds")

#Sum the emissions for each year in Baltimore 
data.nei.baltimore.road <- with(data.nei, subset(data.nei, fips == "24510" & type == "ON-ROAD"))
data.baltimore.road <- with(data.nei.baltimore.road, aggregate(Emissions, by = list(year), sum))
data.baltimore.road <- tbl_df(data.baltimore.road)
colnames(data.baltimore.road) <- c("year","emissions")

data.nei.la.road <- with(data.nei, subset(data.nei, fips == "06037" & type == "ON-ROAD"))
data.la.road <- with(data.nei.la.road, aggregate(Emissions, by = list(year), sum))
data.la.road <- tbl_df(data.la.road)
colnames(data.la.road) <- c("year","emissions")

data.comp <- left_join(data.baltimore.road, data.la.road, by = "year")
colnames(data.comp) <- c("Year","Emissions_BA", "Emissions_LA")

#Open .png device filestream
png("plot6.png")  

#Plot
ggplot(data.comp, aes(Year, color = city)) + 
  xlab("Year") + ylab(expression('PM'[2.5]*' emission in tons')) +
  ggtitle(expression('Total PM'[2.5]*' for Baltimore City & Los Angeles County vehicles')) +
  geom_line(aes(y = Emissions_BA, colour = "Baltimore City")) + 
  geom_line(aes(y = Emissions_LA, colour = "Los Angeles County"))

#Close .png filestream
dev.off()