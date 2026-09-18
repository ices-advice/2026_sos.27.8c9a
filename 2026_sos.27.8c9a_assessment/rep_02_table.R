### report.R — TAF reporting script for report table ###

# Create output folder
mkdir("report")

# ------------------------------
# Table 16.1 - catches by country
# ------------------------------

# 1. Read catch data

catch_data <- read_csv(
  "boot/data/Catches/Catches.csv",
  show_col_types = FALSE
)


# 2. Prepare annual catches by country


catch_table <- catch_data %>%
  
  filter(
    species == "Pegusa lascaris",
    catch_category == "Landings"
  ) %>%
  
  group_by(year, country) %>%
  
  summarise(
    catch_t = sum(catch_t, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  
  mutate(
    catch_t = round(catch_t, 0)
  ) %>%
  
  pivot_wider(
    names_from = country,
    values_from = catch_t,
    values_fill = 0
  ) %>%
  
  mutate(
    France = ifelse(France < 1 & France > 0, "<1", France),
    
    Total =
      as.numeric(Portugal) +
      as.numeric(Spain) +
      ifelse(France == "<1", 0, as.numeric(France))
  ) %>%
  
  mutate(
    year = case_when(
      year %in% c(2009, 2010) ~ paste0(year, "*"),
      year == 2025 ~ paste0(year, "**"),
      TRUE ~ as.character(year)
    )
  ) %>%
  
  rename(
    Year = year,
    Portugal = Portugal,
    Spain = Spain,
    France = France
  ) %>%
  
  select(
    Year,
    Portugal,
    Spain,
    France,
    Total
  )

# ---------------------------------------------------------------------
# 4. Create flextable
# ---------------------------------------------------------------------

ft <- flextable(catch_table)

ft <- set_caption(
  ft,
  caption = "Table X. Annual landings (tonnes) of Pegusa lascaris by country."
)

ft <- theme_booktabs(ft)

ft <- align(
  ft,
  align = "center",
  part = "all"
)

ft <- autofit(ft)

# ---------------------------------------------------------------------
# 5. Export to Word
# ---------------------------------------------------------------------

doc <- read_docx()

doc <- body_add_flextable(
  doc,
  value = ft
)

print(
  doc,
  target = "report/Table_Pegusa_lascaris_catches.docx"
)
