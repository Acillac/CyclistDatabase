library(tidyverse)
library(skimr)
library(janitor)
library (dplyr)
library (lubridate)

## Import all csv files from each month
Trips_Jan22 <- read_csv('202201-divvy-tripdata.csv')
Trips_Feb22 <- read_csv('202202-divvy-tripdata.csv')
Trips_Mar22 <- read_csv('202203-divvy-tripdata.csv')
Trips_Apr22 <- read_csv('202204-divvy-tripdata.csv')
Trips_May22 <- read_csv('202205-divvy-tripdata.csv')
Trips_Jun22 <- read_csv('202206-divvy-tripdata.csv')
Trips_Jul22 <- read_csv('202207-divvy-tripdata.csv')
Trips_Aug22 <- read_csv('202208-divvy-tripdata.csv')
Trips_Sep22 <- read_csv('202209-divvy-publictripdata.csv')
Trips_Oct22 <- read_csv('202210-divvy-tripdata.csv')
Trips_Nov22 <- read_csv('202211-divvy-tripdata.csv')
Trips_Dec22 <- read_csv('202212-divvy-tripdata.csv')

## Check to see if all column names are matched up
compare_df_cols(Trips_Jan22, Trips_Feb22, Trips_Mar22, 
                Trips_Apr22, Trips_May22, Trips_Jun22, 
                Trips_Jul22, Trips_Aug22, Trips_Sep22, 
                Trips_Oct22, Trips_Nov22, Trips_Dec22, return = "mismatch")

## Converted all column names to match up with each dataset
Trips_Jan22 <- Trips_Jan22 %>% mutate(started_at = mdy_hm(started_at), ended_at = mdy_hm(ended_at))

all_trips_year <- bind_rows(Trips_Jan22, Trips_Feb22, Trips_Mar22,
                            Trips_Apr22, Trips_May22, Trips_Jun22,
                            Trips_Jul22, Trips_Aug22, Trips_Sep22,
                            Trips_Oct22, Trips_Nov22, Trips_Dec22)

## Remove all unnecessary columns
all_trips_year <- all_trips_year %>% select(-c(ride_length))
str(all_trips_year)
skim(all_trips_year)

all_trips_year$date <- as.Date(all_trips_year$started_at)
all_trips_year$month <- format(as.Date(all_trips_year$date), "%m")
all_trips_year$day <- format(as.Date(all_trips_year$date), "%d")
all_trips_year$year <- format(as.Date(all_trips_year$date), "%Y")
all_trips_year$day_of_week <- format(as.Date(all_trips_year$date), "%A")

all_trips_year$ride_length <- difftime(all_trips_year$ended_at, all_trips_year$started_at)
all_trips_year$ride_length <- as.numeric(as.character(all_trips_year$ride_length))
all_trips_cleaned <- all_trips_year[!(all_trips_year$ride_length < 0),]

write.csv(all_trips_cleaned, "data.csv")
