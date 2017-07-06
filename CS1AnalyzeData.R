### Analyze Data ####################################################################################
# Sort data ascending by GDP and identify the 13th country post sort.
MergeGDPandStat <- arrange(MergeGDPandStat, GDP_USD)
cat(MergeGDPandStat$Long.Name[13], "is the country with the 13th lowest GDP.  ")

# Calculate average GDP rankings for the "High income: OECD" and "High income: nonOECD" groups
HIOECDGDP <- subset(MergeGDPandStat, MergeGDPandStat$Income.Group == "High income: OECD")
cat("The mean GDP ranking for High income: OECD countries is", mean(HIOECDGDP$Ranking), ".  ")

HINOECDGDP <- subset(MergeGDPandStat, MergeGDPandStat$Income.Group == "High income: nonOECD")
cat("The mean GDP ranking for High income: nonOECD countries is", mean(HINOECDGDP$Ranking, na.rm = TRUE), ".  ")

# Plot Bar Graph of Total GDP by Income Group. 
ggplot(MergeGDPandStat, aes(MergeGDPandStat$Income.Group, MergeGDPandStat$GDP_USD)) +geom_bar(stat = "identity", aes(fill = Income.Group)) +labs(x = "Income Group", y = "GDP")

#Plot boxplot of GDP by Income Group on a log10 scale
ggplot(MergeGDPandStat, aes(MergeGDPandStat$Income.Group, MergeGDPandStat$GDP_USD)) +geom_boxplot(aes(fill = Income.Group)) +labs(x = "Income Group", y = "GDP") +scale_y_log10()

#Plot all countries by GDP on a log10 scale.
ggplot(MergeGDPandStat, aes(x = reorder(MergeGDPandStat$CountryCode, MergeGDPandStat$GDP_USD), MergeGDPandStat$GDP_USD)) +geom_bar(stat = "identity", aes(fill = Income.Group)) +labs(x = "Income Group", y = "GDP (log10 scale)") +scale_y_continuous(trans = "log10")

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
cat(nrow(Q5), "countries are Lower middle income and among the 38 nations with highest GDP.  ")