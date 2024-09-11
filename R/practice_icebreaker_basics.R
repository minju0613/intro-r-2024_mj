#### Practice Problem: Loading and manipulating a data frame ####
# Don't forget: Comment anywhere the code isn't obvious to you!

# Load the readxl and dplyr packages
library(readxl)
library(dplyr)
# Use the read_excel function to load the class survey data
icebreaker_answers <- read_excel("data/icebreaker_answers.xlsx")
View(icebreaker_answers)
# Take a peek!

# Create a travel_speed column in your data frame using vector operations and 
#   assignment
t <- icebreaker_answers$travel_time
d <- icebreaker_answers$travel_distance
icebreaker_answers$travel_speed <- d/t*60
  
# Look at a summary of the new variable--seem reasonable?
summary(icebreaker_answers$travel_speed)

# Choose a travel mode, and use a pipe to filter the data by your travel mode
icebreaker_answers |>
  filter(
    travel_mode == "bus"
  )
# Note the frequency of the mode (# of rows returned)
5
# Repeat the above, but this time assign the result to a new data frame
bus_answers <- icebreaker_answers |>
  filter(
    travel_mode == "bus"
  )
# Look at a summary of the speed variable for just your travel mode--seem 
#   reasonable?
summary(bus_answers)

# Filter the data by some arbitrary time, distance, or speed threshold
icebreaker_answers |>
  filter(
    travel_time > 30,
    travel_distance > 5
  )
# Stretch yourself: Repeat the above, but this time filter the data by two 
#   travel modes (Hint: %in%) 
# Using "%in%" function and "c()" makes shorter code than using OR function "|"
icebreaker_answers |>
  filter(
    travel_mode %in% c("bus", "car")
  )

icebreaker_answers |>
  filter(
    travel_mode == "bus" | travel_mode == "car"
  )
