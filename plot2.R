#plot2.R creates a plot to answer the following question:

#Have total emissions from PM2.5 decreased in the Baltimore City,
#Maryland (fips == "24510") from 1999 to 2008? Use the base plotting
#system to make a plot answering this question.


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

#Sum the emissions for each year in Baltimore 
data.nei.baltimore <- subset(data.nei, fips == 24510)
data.baltimore <- with(data.nei.baltimore, aggregate(Emissions, by = list(year), sum))
data.baltimore <- tbl_df(data.baltimore)
colnames(data.baltimore) <- c("year","emission")

#Open .png device filestream
png("plot2.png")  

#Make y-axis labels horizontal
par(las=1)

#Plot emissions
plot(x = data.baltimore$year, y = data.baltimore$emission, type = "b", 
     main = expression('Total PM'[2.5]*' from Baltimore per year'), 
     xlab = "Year", ylab = expression('Total PM'[2.5]*' emission in tons'), 
     pch = 19, col = "black", xaxt = "n", yaxt = "n")

#Modify values for x-axis labels 
axis(1,at=data.baltimore$year)

#Modify values for y-axis labels
axis(2,at=data.baltimore$emission_mt)        

#Close .png filestream
dev.off()