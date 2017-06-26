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

#Coerce Columns to correct data types
GDPdata$CountryCode <- as.factor(GDPdata$CountryCode)
GDPdata$Ranking <- as.integer(GDPdata$Ranking)
GDPdata$GDP_USD <- gsub(",", "", GDPdata$GDP_USD)
GDPdata$GDP_USD <- as.numeric(GDPdata$GDP_USD)

# Create Income Group Data Frame from the bottom rows of GDPdata.  Create JustGDPData data frame to house only GDP amounts and rankings per country
# The income group is a higher level classification of GDP when compared to country level data.
IncomeGroup <- subset(GDPdata, as.numeric(rownames(GDPdata)) > 217)
JustGDPdata <- subset(GDPdata, as.numeric(rownames(GDPdata)) <= 217 & CountryCode != 'WLD')
IncomeGroup <- rename(IncomeGroup, IG_GDP_USD = GDP_USD)

# Delete blank columns from Income Group
IncomeGroup <- subset(IncomeGroup, select = -(c(2,5)))

# Merge Files and print statement indicating the number of matches.  Then remove NA values.
MergeGDPandStat <- merge(JustGDPdata, FedStats, by="CountryCode")
cat("There are", nrow(MergeGDPandStat), "matches between GDPdata and FedSTATS.")
MergeGDPandStat <- subset(MergeGDPandStat, complete.cases(MergeGDPandStat$Ranking) == TRUE)

# Sort data ascending by GDP and identify the 13th country post sort.
MergeGDPandStat <- arrange(MergeGDPandStat, GDP_USD)
cat(MergeGDPandStat$Long.Name[13], "is the country with the 13th lowest GDP.")

# Calculate average GDP rankings for the "High income: OECD" and "High income: nonOECD" groups
HIOECDGDP <- subset(MergeGDPandStat, MergeGDPandStat$Income.Group == "High income: OECD")
cat("The mean GDP ranking for High income: OECD countries is", mean(HIOECDGDP$Ranking))

HINOECDGDP <- subset(MergeGDPandStat, MergeGDPandStat$Income.Group == "High income: nonOECD")
cat("The mean GDP ranking for High income: nonOECD countries is", mean(HINOECDGDP$Ranking, na.rm = TRUE))

# Plot GDP for all countries by Income Group. 
#ADD COLOR BY INCOME GROUP
ggplot(MergeGDPandStat, aes(MergeGDPandStat$Income.Group, MergeGDPandStat$GDP_USD)) +geom_bar(stat = "identity", aes(fill = Income.Group))

# Create quantile groups for GDP Rankings and compare to Income Group (Gartner MQ Style).  
#create new column in MergeGDPandStat for Quantile group based on GDPRankQuant.  
int1 <- round((max(MergeGDPandStat$Ranking)/5))
int2 <- round((max(MergeGDPandStat$Ranking)/5*2))
int3 <- round((max(MergeGDPandStat$Ranking)/5*3))
int4 <- round((max(MergeGDPandStat$Ranking)/5*4))
int5 <- round(max(MergeGDPandStat$Ranking))
MergeGDPandStat$QuantileGroup <- findInterval(MergeGDPandStat$Ranking, c(0, int1, int2, int3, int4, int5), rightmost.closed = TRUE)

# subset MergeGDPandStat to get table with Quantile Group 1 and income group of 'Lower Middle Income'
Q5 <- subset(MergeGDPandStat, MergeGDPandStat$QuantileGroup=="1" & MergeGDPandStat$Income.Group=="Lower middle income")
cat(nrow(Q5), "countries are Lower middle income and among the 38 nations with highest GDP")
#Q5Count <- count(MergeGDPandStat, MergeGDPandStat$QuantileGroup=="1" & MergeGDPandStat$Income.Group=="Lower middle income", sort = FALSE)