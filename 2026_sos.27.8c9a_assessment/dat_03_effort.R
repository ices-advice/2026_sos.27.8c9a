## Script to read Portuguese polyvalent fleet effort ###
#
# Input: effort file for the assessment year
#
# Output: effort table and csv file for report
#
# Authors: M. Grazia Pennino
#

# Create output folder
mkdir("data/Effort")


# Read effort data
effort_data <- read.csv("boot/data/Effort/Effort.txt",sep = ";")

# Prepare Portuguese polyvalent fleet effort

effort_polyvalent <- effort_data %>%
  select(
    Year,
    POLYVALENT
  ) %>%
  rename(
    Effort = POLYVALENT
  ) %>%
  mutate(
    Year = as.integer(Year),
    Effort = as.numeric(Effort)
  )


# Save processed data

write.csv(effort_polyvalent,file = "data/Effort/Portuguese_polyvalent_effort.csv",row.names = FALSE)

