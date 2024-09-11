library(dplyr)
library(ggplot2)

# Import data sets
detectors <- read.csv("data/portal_detectors.csv", stringsAsFactors = F)
stations <- read.csv("data/portal_stations.csv", stringsAsFactors = F)
data <- read.csv("data/agg_data.csv", stringsAsFactors = F)

head(data)
table(data$detector_id) 

# join data and detector data frame by detector_id
data_detectors <- data |>
  distinct(detector_id)

data_detectors_meta <- data_detectors |>
  left_join(detectors, by = c("detector_id" = "detectorid")) # c (target file column = join file column)
