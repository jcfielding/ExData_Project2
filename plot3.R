#plot3.R creates a plot to answer the following question:

#Of the four types of sources indicated by the type 
#(point, nonpoint, onroad, nonroad) variable, which 
#of these four sources have seen decreases in emissions
#from 1999-2008 for Baltimore City? Which have seen increases
#in emissions from 1999-2008? Use the ggplot2 plotting system
#to make a plot answer this question.

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
data.nei.baltimore <- subset(data.nei, fips == 24510)
data.baltimore.source <- with(data.nei.baltimore, aggregate(Emissions, by = list(type = type, year = year), sum))
data.baltimore.source <- tbl_df(data.baltimore.source)
colnames(data.baltimore.source) <- c("type","year","emission")

#Open .png device filestream
png("plot3.png") 

#Plot using ggplot2
qplot(year, emission, data = data.baltimore.source, 
      color = type, geom = "line") + 
      ggtitle(expression('Total PM'[2.5]*' emissions by source type in Baltimore per year')) +
      xlab("Year") + ylab(expression('Total PM'[2.5]*' emission in tons'))   

#Close .png filestream
dev.off()