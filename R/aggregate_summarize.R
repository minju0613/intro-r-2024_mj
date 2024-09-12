#### Aggregating and Summarizing Data ####
# DT (creating table function)
# Load packages ----
library(readxl) # read excel
library(dplyr) # manipulation
library(ggplot2) # visualization

# Read in the excel file ----
df <- read_excel("data/icebreaker_answers.xlsx")
df
summary(df)

# Custom summaries of an entire data frame by column ----
df |> 
  summarize(
    avg_dist = mean(travel_distance),
    sd_dist = sd(travel_distance),
    pct60_dist = quantile(travel_distance, prob = 0.6),
    avg_time = mean(travel_time)
  )

# on aside, if you want an integer, must specify
df |> 
  mutate(
    travel_time = as.integer(travel_time)
    )

# assign the summary if you want to save
# View () may show more precision
df_summ <- df |> 
  summarize(
    avg_dist = mean(travel_distance),
    sd_dist = sd(travel_distance),
    pct60_dist = quantile(travel_distance, prob = 0.6),
    avg_time = mean(travel_time)
    )
# View(df_summ) # same as clicking df_summ in Environment window

# Aggregating and summarizing subsets ----
#   of a data frame
df <- df |>
  mutate(
    travel_speed = travel_distance / travel_time * 60
  )

df |>
  summarize(
    avg_speed = mean(travel_speed)
    )

# average speed by mode (using "group_by" function)
df |> 
  group_by(travel_mode) |>
  summarize(
    avg_speed = mean(travel_speed)
    )

# sort by avg_speed (using "arrange" function)
df |> 
  group_by(travel_mode) |>
  summarize(
    avg_speed = mean(travel_speed)
  ) |>
  arrange(desc(avg_speed))

# grouped data frame
df_mode_grp <- df |>
  group_by(travel_mode)
str(df_mode_grp)

# grouping by multiple variables
#   by default, summarize will leave data grouped by next higher level (first order in group_by)
df_mode_comma_grp <- df |>
  group_by(travel_mode, serial_comma) |>
  summarize(
    avg_speed = mean(travel_speed)
  )

# have to explicitly ungroup ()
df_mode_comma_ungrp <- df |>
  group_by(travel_mode, serial_comma) |>
  summarize(
    avg_speed = mean(travel_speed)
  ) |>
  ungroup()
df_mode_comma_ungrp

# Frequency ----
#   so common there are shortcuts
df |> 
  group_by(serial_comma) |>
  summarize(n = n()) 

df |> 
  group_by(serial_comma) |>
  tally() # tally() means summarize(n=n())

df |>
  count(serial_comma) # count() means group_by() |> summarize(n=n())
# can arrange this also by descending
df |>
  count(serial_comma, sort=T) # where T is for TRUE

# calculate a mode split (percentage using each travel mode)
df |> count(travel_mode)

df |>
  group_by(travel_mode) |>
  summarize(split = n() / nrow(df) * 100) |>  # nrow = total number of row
  arrange(desc(split))
