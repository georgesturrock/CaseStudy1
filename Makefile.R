###
### Title:  MSDS6303 Case Study 1 Makefile
### Team:  Chayson Comfort, Phillip Edwards, George Sturrock
### Description:  Makefile.R is a Make-like file used to control the flow of logic for downloading, reading, cleansing and analyzing data.
###
# In addtion to the base libaries loaded with R, the following libraries are utilized in the Case Study 1:  downloader, dplyr and ggplot2
source("CS1LoadLibraries.R")
cat("Libraries Loaded")

# Download and Read Data
source("CS1DLoadandRead.R")
cat("Data Downloaded and Read")

# Cleanse GDP and FedSTAT data
source("CS1CleanseData.R")
cat("Data Cleansed")

# Analyze Data
source("CS1AnalyzeData.R")
cat("Data Analyzed")