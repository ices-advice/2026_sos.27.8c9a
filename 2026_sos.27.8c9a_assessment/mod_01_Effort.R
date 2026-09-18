### Script to perform effort data analysis ###
# Input: Portuguese_polyvalent_effort.csv
# Output: diagnostic plots
# Author: M. Grazia Pennino


# Create output folder if needed
mkdir("output")
mkdir("output/Effort")

# Load input data
effort <- read.csv("data/Effort/Portuguese_polyvalent_effort.csv")

# Create time series object 
ntrips_pol.ts <- ts(
  effort$Effort,
  start = 2015,
  freq = 1
)

# Select last 10 years
effort_10y <- tail(ntrips_pol.ts, 10)


# Apply Mann-Kendall trend test
mk <- MannKendall(effort_10y)

# Save Mann-Kendall results

capture.output(
  mk,
  file = "output/Effort/MannKendall_Effort.txt"
)

