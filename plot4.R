#plot4.R creates a plot to answer the following question:

#Across the United States, how have emissions from coal combustion-related
#sources changed from 1999-2008?

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

#Get the total emissions from coal
data.coal.id <- grep("Coal", data.scc$EI.Sector, value = T)
data.coal.data <- subset(data.scc, data.scc$EI.Sector %in% data.coal.id)
data.coal.nei <- subset(data.nei, data.nei$SCC %in% data.coal.data$SCC)
data.coal <- with(data.coal.nei, aggregate(Emissions, by = list(year = year), sum))
data.coal <- tbl_df(data.coal)
colnames(data.coal) <- c("year","emissions")

#Scale the emissions to kilotons
data.coal$emissions_kt <- round(data.coal$emissions/1000,digits=-1)

#Open .png device filestream
png("plot4.png")  

#Make y-axis labels horizontal
par(las=1)

#Plot emissions
plot(x = data.coal$year, y = data.coal$emissions_kt, type = "b",
     main = expression('Total USA PM'[2.5]*' emissions from coal combution'), 
     xlab = "Year", ylab = expression('Total PM'[2.5]*' emissions in kilotons'), 
     pch = 19, col = "black", xaxt = "n", yaxt = "n")

#Modify values for x-axis labels 
axis(1, at = data.coal$year)

#Modify values for y-axis labels
axis(2, at = data.coal$emissions_kt)        

#Close .png filestream
dev.off()