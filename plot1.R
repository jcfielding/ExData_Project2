#plot1.R creates a plot to answer the following question:

#Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
#Using the base plotting system, make a plot showing the total PM2.5 emission from all
#sources for each of the years 1999, 2002, 2005, and 2008.

library(dplyr)

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

#Sum the emissions for each year  
data.nei.emissionsPerYear <- with(data.nei, aggregate(Emissions, by = list(year), sum))

#Make a dataframe
data.total <- tbl_df(data.nei.emissionsPerYear)
colnames(data.total) <- c("year","emission")

#Scale the emissions to megatons
data.total$emission_mt <- round(data.total$emission/1000000,digits=2)

#Open .png device filestream
png("plot1.png")  

#Make y-axis labels horizontal
par(las=1)

#Plot emissions
plot(x = data.total$year, y = data.total$emission_mt, type = "b", main = expression(' PM'[2.5]*' from all sources per year'), xlab = "Year", ylab = expression('Total PM'[2.5]*' emission in megatons'), pch = 19, col = "black", xaxt = "n", yaxt = "n")

#Modify values for x-axis labels 
axis(1,at=data.total$year)

#Modify values for y-axis labels
axis(2,at=data.total$emission_mt)        

#Close .png filestream
dev.off()