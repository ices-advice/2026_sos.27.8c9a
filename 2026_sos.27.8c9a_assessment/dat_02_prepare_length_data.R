### Prepare long-format length data from InterCatch LFDs ###
# Output: data/Lenght_data/Size.csv
# Author: M. Grazia Pennino

# Create output folder
mkdir("data/Lenght_data")


#read data
data <- read_delim("boot/data/LFDs nsample intercatch/NumbersAtAgeLength.txt",
  delim = "\t",
  skip = 1,
  trim_ws = TRUE,
  show_col_types = FALSE
)

# names(data)  # <- quitar/comentar esta línea

data_2025 <- data %>%
  filter(Year == 2025)

length_cols <- grep("^UndeterminedLngt", names(data_2025), value = TRUE)

talla_2025 <- data_2025 %>%
  select(all_of(length_cols)) %>%
  pivot_longer(
    cols = everything(),
    names_to = "length_class",
    values_to = "n_ind"
  ) %>%
  mutate(
    length_cm = as.numeric(gsub("UndeterminedLngt", "", length_class)) / 10
  ) %>%
  group_by(length_cm) %>%
  summarise(n_ind = sum(n_ind, na.rm = TRUE), .groups = "drop")

# save
write.csv(talla_2025, "data/Lenght_data/Size.csv", row.names = FALSE)

