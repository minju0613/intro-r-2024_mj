# Read in csv file using base R
sta_meta <- read.csv("data/portal_stations.csv", stringsAsFactors = F) # "directory(folder) within the project folder/name of file", strings as Factors = F

str(sta_meta) # structure of data (name of attributes, types)

head(sta_meta) # first six rows of data
tail(sta_meta) # last six rows of data

nrow(sta_meta) # number of rows of data

summary(sta_meta) # summary of data, can get some information about NA

# Using Data Import shortcut to read in xlsx and copy/paste code from Console as well as History (on the right top)
library(readxl)
icebreaker_answers <- read_excel("data/icebreaker_answers.xlsx")
View(icebreaker_answers)  