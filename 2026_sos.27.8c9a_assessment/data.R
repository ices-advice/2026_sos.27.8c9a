## Preprocess data 
##
## Before: Catch and LFD in boot/data/
## After: Plot for report
##
## Author: M. Grazia Pennino

# Load TAF and other necessary libraries
library(icesTAF)
library(tidyverse)


# Ensure output folders exist
mkdir("data")
mkdir("data/Lenght_data")
mkdir("output")
mkdir("output/Effort")


# Run sequential data preparation scripts

# 1. Read and plot
source("dat_01_intercatch.R")

# 2. Prepare length data from Intercatch files
source("dat_02_prepare_length_data.R")

# 3. Read effort data 
source("dat_03_effort.R")






