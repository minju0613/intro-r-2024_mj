library(dplyr)
library(ggplot2)
library(lubridate)

stations <- read.csv("data/portal_stations.csv", stringsAsFactors = F)
detectors <- read.csv("data/portal_detectors.csv", stringsAsFactors = F)
data <- read.csv("data/agg_data.csv", stringsAsFactors = F)

str(detectors)
head(detectors$start_date)

# list of acceptable timezones
OlsonNames()

# convert detector$start_date and detector$end_date to date/time format with US/Pacific time zone
detectors$start_date <- ymd_hms(detectors$start_date) |>
  with_tz("US/Pacific")
detectors$end_date <- ymd_hms(detectors$end_date) |>
  with_tz("US/Pacific")

# open detectors
open_det <- detectors |>
  filter(is.na(end_date))
# closed detectors
closed_det <- detectors |>
  filter(!is.na(end_date))

#### I want the total daily volume and average volume and average speed/station ####
# join aggregated data and opened detector data first by detector id
data_stid <-  data |>
  left_join(open_det, by = c("detector_id" = "detectorid")) |>
  select(detector_id, starttime, volume, speed, countreadings, stationid)

# convert starttime to datetime format
data_stid$starttime <- ymd_hms(data_stid$starttime) |>
  with_tz("US/Pacific")

# aggregate daily data from hourly data
daily_data <- data_stid |>
  mutate(date = floor_date(starttime, unit = "day")) |>
  group_by(stationid,
           date) |> # aggregated by station id and date
  summarize(
    daily_volume = sum(volume),
    daily_obs = sum(countreadings),
    mean_speed = mean(speed)
  ) |>
  as.data.frame()  # make the dataframe structure clear 

# plot data to check it out
daily_volume_fig <- daily_data |>
  ggplot(aes(x = date, y = daily_volume)) + 
  geom_line() +
  geom_point() +
  facet_grid(stationid ~ ., scales = "free")
daily_volume_fig

# install packages at "packages" tab on the right
library(plotly)
ggplotly(daily_volume_fig) # showing the point where it represent from the data, see in "Viewer", not in "Plots"

length(unique(daily_data$stationid)) # length gives number of row: 23 stations in data frame

# expecting 31 days for each station and create new data frame with date 
#   > create NA for missing date for each station
stids <- unique(daily_data$stationid)

start_date <- ymd("2023-03-01")
end_date <- ymd("2023-03-31")
date_df <- data.frame(
  date_seq = rep(seq(start_date, end_date, by = "1 day")),
  station_id = rep(stids, each = 31)
)

# create NA for missing date for each station
data_with_gaps <- date_df |>
  left_join(daily_data, by =c("date_seq" = "date",
                              "station_id" = "stationid")
            )

# export data frame as various format
write.csv(data_with_gaps, "data/data_with_gaps.csv", row.names = F) # save data frame as csv file > data structure, string would be changed when it is reimported.
saveRDS(data_with_gaps, "data/data_with_gaps.rds") # don't have any issue on reimporting

mod_date_fig <- data_with_gaps |>
  filter(station_id %in% c(1056, 1057, 1059)) |>
  ggplot(aes(x = date_seq, y = daily_volume)) + 
  geom_line(aes(color = "blue")) +
  geom_point(aes(color = "skyblue")) + 
  facet_grid(station_id ~ .)
mod_date_fig

# see within specific date
mod_date_fig <- data_with_gaps |>
  filter(station_id %in% c(1056, 1057, 1059)) |>
  ggplot(aes(x = as.Date(date_seq), y = daily_volume)) + 
  geom_line() +
  geom_point() + 
  facet_grid(station_id ~ .) +
  scale_x_date(date_breaks = "1 day") + # fixed to as.date
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
  geom_hline(yintercept = mean(daily_data$daily_volume))

mod_date_fig
