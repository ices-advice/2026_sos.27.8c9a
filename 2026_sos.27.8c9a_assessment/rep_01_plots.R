### report.R — TAF reporting script for report plots ###

# Create output folder
mkdir("report")



# === FIGURE 16.1: Catch by Country ===
# Copy Figure_16_1 from Catch to REPORT folder
file.copy(
  from = "output/Catch/Figure_16_1.jpg",
  to   = "report/Figure_16_1.jpg",
  overwrite = TRUE
)

# === FIGURE 16.2: Catch by Fleet ===
catch_detail <- read_csv(
  "boot/data/Catches/Catches.csv",
  show_col_types = FALSE
)

# 2. Prepare fleet contribution by country and year

fleet_country_year_pct <- catch_detail %>%
  filter(
    catch_category == "Landings",
    fleet != "Unknown",
    year >= 2019
  ) %>%
  mutate(
    fleet = case_when(
      fleet == "DTRAWL" ~ "OTB",
      fleet == "POLYVALENT" ~ "MIS_MIS_0_0_0",
      country == "France" &
        fleet == "OTM_DEF_70-99_0_0_all" ~ "OTB",
      TRUE ~ fleet
    )
  ) %>%
  group_by(country, year, fleet) %>%
  summarise(
    total_catch = sum(catch_t, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  group_by(country, year) %>%
  mutate(
    pct = total_catch / sum(total_catch, na.rm = TRUE) * 100
  ) %>%
  ungroup()

# 3. Identify main fleets
top_fleets <- fleet_country_year_pct %>%
  group_by(fleet) %>%
  summarise(
    total = sum(total_catch, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  slice_max(total, n = 5) %>%
  pull(fleet)


# 4. Group minor fleets as Other

fleet_country_year_plot <- fleet_country_year_pct %>%
  mutate(
    fleet_group = case_when(
      country == "France" & fleet == "OTB" ~ "OTB",
      fleet %in% top_fleets ~ fleet,
      TRUE ~ "Other"
    )
  ) %>%
  group_by(country, year, fleet_group) %>%
  summarise(
    pct = sum(pct, na.rm = TRUE),
    .groups = "drop"
  )

# 5. Create plot

p_fleet <- ggplot(
  fleet_country_year_plot,
  aes(
    x = factor(year),
    y = pct,
    fill = fleet_group
  )
) +
  geom_col(
    color = "black",
    linewidth = 0.2
  ) +
  facet_wrap(~ country) +
  labs(
    x = "Year",
    y = "Contribution (%)",
    fill = "Fleet",
    title = "Temporal evolution of fleet composition since 2019"
  ) +
  theme_bw(base_size = 12) +
  theme(
    legend.position = "right",
    panel.grid = element_blank(),
    axis.text.x = element_text(angle = 90, vjust = 0.5)
  )


# 6. Save plot

jpeg(
  filename = "report/Figure_16_2.jpg",
  width = 2200,
  height = 1600,
  res = 300)

dev.off()


# === FIGURE 16.3: Length–frequency distribution  ===

size=read.csv("data/Lenght_data/Size.csv")
p_size=ggplot(size, aes(x = length_cm, y = n_ind)) +
  geom_col() +
  labs(
    x = "Length (cm)",
    y = "Number of individuals",
    title = "Length distribution of Pegusa lascaris in 2025 IC"
  ) +
  theme_bw()

jpeg("report/Figure_16_3.jpg", width = 2000, height = 1600, res = 300)
print(p_size)
dev.off()


# === FIGURE 16.4: Temporal trends in fishing effort (number of trips)  ===
# 1. Read processed data

effort_series <- read_csv(
  "output/SAG/portuguese_polyvalent_effort_series.csv",
  show_col_types = FALSE
)

catch_trip_series <- read_csv(
  "output/SAG/portuguese_polyvalent_catch_per_trip_series.csv",
  show_col_types = FALSE
)

# 2. Join series

plot_data <- effort_series %>%
  left_join(
    catch_trip_series %>%
      select(year, catch_t, catch_per_trip),
    by = "year"
  ) %>%
  filter(year %in% 2011:2025)



p_effort <- ggplot(plot_data, aes(x = year, y = trips)) +
  geom_line(linewidth = 1.1, colour = "black") +
  scale_x_continuous(breaks = 2011:2025) +
  scale_y_continuous(
    limits = c(0, 45000),
    breaks = seq(0, 45000, by = 5000)
  ) +
  labs(
    x = "Year",
    y = "Number of trips"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(angle = 0),
    plot.title = element_blank()
  )



jpeg(filename = "report/Figure_16_4.jpg",width = 2000, height = 1600, res = 300)
print(p_effort)
dev.off()

# === FIGURE 16.5: Temporal trends in catch per trip  ===

p_catch_trip <- ggplot(plot_data, aes(x = year, y = catch_per_trip)) +
  geom_line(linewidth = 1.1, colour = "black") +
  scale_x_continuous(breaks = 2011:2025) +
  scale_y_continuous(
    limits = c(0, 0.008),
    breaks = seq(0, 0.008, by = 0.001),
    labels = number_format(accuracy = 0.0001)
  ) +
  labs(
    x = "Year",
    y = "Catch/Trips"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(angle = 0),
    plot.title = element_blank()
  )

print(p_catch_trip )
dev.off()