library(dplyr)
library(ggplot2)
library(readxl)

# load data
df_ice <- read_xlsx("data/icebreaker_answers.xlsx")

tt_mi_fig <- df_ice |>
  ggplot(
    aes(x = travel_time, y = travel_distance)
    ) +  # "+" adding layer on the plot
    geom_point()
tt_mi_fig

tt_mi_ox_fig <- df_ice |>
  ggplot(
    aes(x = travel_time, y = travel_distance, color = serial_comma)
  ) + 
  geom_point() +
  xlab("Travel Time") + # x label
  ylab("Travel Distance") # y label
tt_mi_ox_fig

tt_mi_2 <- tt_mi_ox_fig + # using the previous figure data frame and adding new layer
  theme_bw()
tt_mi_2

# create new figure using mode instead of serial_comma
tt_mi_mode_fig <- df_ice |>
  ggplot(
    aes(x = travel_time, y = travel_distance, color = travel_mode)
  ) + 
  geom_point() + 
  xlab("Travel Time") +
  ylab("Travel Distance") + 
  theme_bw()

tt_mi_mode_fig

tt_mi_mode_fig <- tt_mi_mode_fig +
  scale_fill_discrete(name = "Travel Mode", labels=c("Bike", "Bus", "Car", "Light Rail", "Street Car")) ###? didn't change

# Faceting
ice_facet_fig <- df_ice |>
  ggplot(aes(x = travel_time, y = travel_distance)) + 
  geom_point() + 
  facet_grid(travel_mode ~ .,
             scales = "free")
ice_facet_fig  

tt_mode_car_fig <- df_ice |>
  filter(travel_mode == "car") |>
  ggplot(aes(x = travel_time, y = travel_distance)) + 
  geom_point() + 
  theme_bw()
tt_mode_car_fig
