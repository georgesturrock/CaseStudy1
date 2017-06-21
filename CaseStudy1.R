### Case Study 1
# Load Libraries
library(downloader)
library(dplyr)
library(ggplot2)

# Dowload GDP and educational data
download("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", destfile = "GDPdata.csv")
download("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", destfile = "FEDSTATS.csv")

# Read CSV Data 
GDPdata <- read.csv("GDPdata.csv", stringsAsFactors = FALSE, header = FALSE, skip = 5, skipNul = TRUE)
FedStats <- read.csv("FEDSTATS.csv", stringsAsFactors = FALSE, header = TRUE)

### Cleanse GDPdata ##################################################################
# Delete blank columns from GDPdata
delcols <- c(3, 7:10)
GDPdata <- subset(GDPdata, select=-delcols)

# Rename columns
GDPdata <- rename(GDPdata, CountryCode = V1, Ranking = V2, Economy = V4, GDP_USD = V5)

# Remove blank rows
GDPdata <- subset(GDPdata, CountryCode != "")

# Create Income Group Data Frame from the bottom rows of GDPdata.  
# The income group is a higher level classification of GDP when compared to country level data.
IncomeGroup <- subset(GDPdata, as.numeric(rownames(GDPdata)) > 217)
GDPdata <- subset(GDPdata, as.numeric(rownames(GDPdata)) <= 217)

# Merge Files

# Sort data ascending by GDP

# Calculate average GDP rankings for the "High income: OECD" and "High income: nonOECD" groups

# Plot GDP for all countries


# Create quantile groups for GDP Rankings and compare to Income Group (Gartner MQ Style).  
## Try using quantile() function

