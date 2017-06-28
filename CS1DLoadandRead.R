# Dowload GDP and educational data
download("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", destfile = "GDPdata.csv")
download("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", destfile = "FEDSTATS.csv")

# Read CSV Data 
GDPdata <- read.csv("GDPdata.csv", stringsAsFactors = FALSE, header = FALSE, skip = 5, skipNul = TRUE)
FedStats <- read.csv("FEDSTATS.csv", stringsAsFactors = FALSE, header = TRUE)