# Input: catch,  effort
# Output: processed files for report and SAG plots
# Author: M. Grazia Pennino


# Create output folder if needed
mkdir("output/SAG")

# 1. Read catch data
catch_detail <- read_csv("boot/data/Catches/Catches.csv",show_col_types = FALSE)

# 2. Read effort data

effort_raw <- read.csv("boot/data/Effort/Effort.txt", sep = ";")

# 3. Prepare Portuguese polyvalent effort series

effort_series <- effort_raw %>%
  rename(year = Year) %>%
  select(
    year,
    trips = POLYVALENT
  ) %>%
  mutate(
    year = as.integer(year),
    trips = as.numeric(trips)
  ) %>%
  filter(year %in% 2011:2025)

# 4. Prepare annual Sand sole catches

catch_series <- catch_detail %>%
  filter(
    year %in% 2011:2025,
    country == "Portugal",
    species == "Pegusa lascaris",
    grepl("MIS|Polyvalent", fleet, ignore.case = TRUE)
  ) %>%
  group_by(year) %>%
  summarise(
    catch_t = sum(catch_t, na.rm = TRUE),
    .groups = "drop"
  )


# 5. Create catch-per-trip series

catch_per_trip_series <- effort_series %>%
  left_join(catch_series, by = "year") %>%
  mutate(
    catch_t = replace_na(catch_t, 0),
    catch_per_trip = catch_t / trips
  ) %>%
  select(
    year,
    catch_t,
    trips,
    catch_per_trip
  )


# 6. Save output files for later plotting

write_csv(
  effort_series,
  "output/SAG/portuguese_polyvalent_effort_series.csv"
)

write_csv(
  catch_per_trip_series,
  "output/SAG/portuguese_polyvalent_catch_per_trip_series.csv"
)
