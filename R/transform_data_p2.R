#### Transforming Data Part 2 ####
library(readxl)
library(dplyr)

# Load in our data from Excel
df <- read_excel("data/icebreaker_answers.xlsx")
df
tail(df)

df <- df |>
  bind_rows(slice_tail(df)) # take last row and add to end of df

df <- df |>
  distinct() # remove rows with duplicate values, returns only 1 unique row per set of values

# selecting columns
# grab all cols except serial_comma
df |> select(travel_mode, travel_distance, travel_time)

df |> select(-serial_comma) # using "-" for dropping column 

df |> select(travel_mode:travel_distance) # using ":" and "name of column" for selecting group of columns

df |> select(starts_with("travel_")) # select by expression

df_travel <- df |> select(-serial_comma)

# mutate and rename ----
# (creating and modifying data frames)
# mutate to add calculated columns
df_travel$travel_speed <- (df_travel$travel_distance / df_travel$travel_time * 60) #mph

df_travel

df_travel <- df_travel |> 
  mutate(travel_speed = travel_distance / travel_time * 60) #create names and expressions with new variable
summary(df_travel)

# if just renaming, rename (new_name = old_name) ----
df_travel <- df_travel |>
  rename(travel_mph = travel_speed) # travel_mph is new name with values from travel_speed
colnames(df_travel) # column names

# if_else and case_when Logic ----
# adding logic to mutate
# if_else ----
df_travel <- df_travel |>
  mutate(long_trip = 
           if_else(travel_distance > 20, 1, 0)
         ) # set values by condition

# case_when ----
table(df_travel$travel_mode)
df_travel <- df_travel |> 
  mutate(slow_trip = 
           case_when(
             travel_mode == "bike" & travel_mph < 12 ~ 1,
             travel_mode == "car" & travel_mph < 25 ~ 1,
             travel_mode == "bus" & travel_mph < 15 ~ 1, 
             travel_mode == "light rail" & travel_mph < 20 ~ 1,
             .default = 0 # ALL FALSE or NA will be assigned this value
             )
         ) # multi-case of if_else 
df_travel

# arrange to order output (ascending is default, putting "desc" for descending)
df_travel |> arrange(travel_mph) |> print(n=23) # starting from slowest to fastest (to see what value have the first case)

df_travel |> arrange(travel_mode, travel_mph) |> print(n=23) # arrange travel_mode first and rearrange by travel_mph 

df_travel |> arrange(desc(travel_mph)) |> print(n=23) # from fastest to slowest

boxplot(df_travel$travel_mph ~ df_travel$long_trip)
