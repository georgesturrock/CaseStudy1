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
Q1 <- nrow(MergeGDPandStat)
cat("There are", nrow(MergeGDPandStat), "matches between GDPdata and FedSTATS.")
MergeGDPandStat <- subset(MergeGDPandStat, complete.cases(MergeGDPandStat$Ranking) == TRUE)