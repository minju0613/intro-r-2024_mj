library(tidycensus) # acts as gateway to the Census API for ACS & Decennial data 
library(dplyr)
library(tidyr)
library(ggplot2)

#### Run on first use if not already stored in R ####
census_api_key("#####", install = T) # installs into R user environment, remove the API key before pushing Git
readRenviron("~/.Renviron") # use Census API key

####

#### User functions ####

####

# get a searchable census variable table ----
v19 <- load_variables(2019, "acs5")
v19 |>
  filter(
    grepl("^B08006_", name) #"^" look at the beginning of the data
  ) |>
  print(n=25)

# get the data for transit, wfh and total workers ----
#   ?get_acs
comm_19_raw <- get_acs(geography = "tract",
                       variables = c(wfh = "B08006_017",
                                     transit = "B08006_008",
                                     tot = "B08006_001"),
                       county = "Multnomah", 
                       state = "OR",
                       year = 2019,
                       survey = "acs5",
                       geometry = FALSE   # can retrieve library (sf) spatial geoms pre-joined
                       )
comm_19_raw # moe = margin of error, 3 rows should be 1 observation (using "pivot_wider")

# 
comm_19 <- comm_19_raw |>
  pivot_wider(
    id_cols = GEOID:NAME,  # just using GEOID is okay
    names_from = variable,
    values_from = estimate:moe
  )
comm_19


#


