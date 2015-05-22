#plot5.R creates a plot to answer the following question:

#How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?

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
data.nei.baltimore.road <- with(data.nei, subset(data.nei, fips == "24510" & type == "ON-ROAD"))
data.baltimore.road <- with(data.nei.baltimore.road, aggregate(Emissions, by = list(year), sum))
data.baltimore.road <- tbl_df(data.baltimore.road)
colnames(data.baltimore.road) <- c("year","emissions")

#Open .png device filestream
png("plot5.png")  

#Make y-axis labels horizontal
par(las=1)

#Plot emissions
plot(x = data.baltimore.road$year, y = data.baltimore.road$emissions, type = "b",
     main = expression('Total PM'[2.5]*' road emissions for Baltimore City'), 
     xlab = "Year", ylab = expression('Total PM'[2.5]*' emissions in tons'), 
     pch = 19, col = "black", xaxt = "n", yaxt = "n")

#Modify values for x-axis labels 
axis(1, at = data.baltimore.road$year)

#Modify values for y-axis labels
axis(2, at = round(data.baltimore.road$emissions,digits=-1))        

#Close .png filestream
dev.off()