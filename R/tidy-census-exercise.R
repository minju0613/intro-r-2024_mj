library(tidycensus) # acts as gateway to the Census API for ACS & Decennial data 
library(dplyr)
library(tidyr)
library(ggplot2)

#### Run on first use if not already stored in R ####
census_api_key("#####", install = T) # installs into R user environment, remove the API key before pushing Git
readRenviron("~/.Renviron") # use Census API key

####

#### User function storage ####
tidy_acs_result <- function(raw_result, include_moe = FALSE) {
  # takes a tidycensus acs result and returns a wide and tidy table
  if (isTRUE(include_moe)) {        # if moe is included
    new_df <- raw_result |>
      pivot_wider(
        id_cols = GEOID:NAME,       # ":" through
        names_from = variable,
        values_from = estimate:moe
      )
  } else {                          # moe is not included
    new_df <- raw_result |>
      pivot_wider(
        id_cols = GEOID:NAME,
        names_from = variable,
        values_from = estimate
      )
  }
  return(new_df)
}
tidy_acs_result
  
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

# Using user function "tidy_acs_result
comm_19 <- tidy_acs_result(comm_19_raw)

# get 2022 ACS data
comm_22_raw <- get_acs(geography = "tract",
                       variables = c(wfh = "B08006_017",
                                     transit = "B08006_008",
                                     tot = "B08006_001"),
                       county = "Multnomah", 
                       state = "OR",
                       year = 2022,
                       survey = "acs5",
                       geometry = FALSE   # can retrieve library (sf) spatial geoms pre-joined
)
comm_22_raw # When compared to comm_19_raw, some GEOID is changed

# applying our function to pivot wider and drop moe's
comm_22 <- tidy_acs_result(comm_22_raw)
comm_22

# Join the years ----
# inner_join: retain only rows with matches.(2019: 171, 2022: 197, combined: 146)
# anti_join: shows the list of not matching join.
comm_19_22 <- comm_19 |>
  inner_join(comm_22, 
             by="GEOID",
             suffix = c("_19", "_22")   # if there is the same name of attributes between data frame
                                        # so, naming with year to make different name
             ) |>
  select(-starts_with("NAME"))          # dropping attributes starting with NAME

# Create some change variables ----
comm_19_22 <- comm_19_22 |>
  mutate(wfh_chg = wfh_22 - wfh_19,
         transit_chg = transit_22 - transit_19
         )
summary(comm_19_22 |>
          select(ends_with("_chg"))     # showing only attributes ending with _chg
        )

# Plot them ----
comm_19_22_fig <- comm_19_22 |>
  ggplot(aes(x = wfh_chg, y = transit_chg)
         ) +
  geom_point() + 
  geom_smooth(method = "lm") +           # showing trends with linear model
  labs(x = "Change in WFH", y = "Change in transit", # change the axis label
       title = "ACS 2022 vs 2019 (5-year)") + # change the title of plot
  annotate("text", x = 800, y = 50,   # number means x, y location 
           label = paste("r =",       # simple linear correlation between wfh_chg and transit_chg
                         round(cor(comm_19_22$wfh_chg,
                                   comm_19_22$transit_chg), 3 # the number is digit
                               )
                         )
           )

comm_19_22_fig

# simple linear (default Pearson) correlation
cor(comm_19_22$wfh_chg, comm_19_22$transit_chg)

# Model it ----
# model formula is dependent variable ~ 1 + X1 + X2 + ...
m <- lm(transit_chg ~ wfh_chg, 
        data = comm_19_22)
summary(m)

# Model is an object ready for re-use!! 
# Using model results
head(m$model) # model comes data included

# Scenario what if wfh is increased by 50%
scen1 <- comm_19_22 |>
  mutate(wfh_chg = wfh_chg * 1.5) 

scen1_pred <- predict(m, newdata = scen1)

# difference in total daily transit impact from 50% increase in WFH changes
sum(comm_19_22$transit_chg)
sum(scen1_pred)

# update(model, data =) function re-estimates model on new data

