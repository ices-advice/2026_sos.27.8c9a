
### Script to read intercatch data ###

# Input: historical catches and intercatch files for the assessment year.
#
# Output: files for report.
#
# Authors: M. Grazia Pennino

# For saving results!
mkdir("data/catch")
mkdir("output/Catch")

rm(list=ls())

#----------------------------------------------------------------------------
# Combine historical catches with the ones of the assessment year 
#----------------------------------------------------------------------------


# 1. Read historical catch data
catch_data  <-read.csv("boot/data/Catches/Catches.csv")

# 2. Prepare data
plot_data <- catch_data %>%
  filter(catch_category == "Landings") %>%
  group_by(year, country) %>%
  summarise(
    Catch = sum(catch_t, na.rm = TRUE),
    .groups = "drop"
  )

# 3. Define country order


plot_data$country <- factor(
  plot_data$country,
  levels = c("Portugal", "Spain", "France")
)

# 4. Create stacked bar plot

p <- ggplot(
  plot_data,
  aes(
    x = year,
    y = Catch,
    fill = country
  )
) +
  geom_bar(
    stat = "identity",
    colour = "black"
  ) +
  scale_fill_grey(
    start = 0.85,
    end = 0.35
  ) +
  labs(
    x = "Year",
    y = "Catches (tonnes)",
    fill = "Country"
  ) +
  theme_bw(base_size = 14) +
  theme(
    panel.grid = element_blank(),
    legend.position = "right"
  )


# 5. Save figure

jpeg( "output/Catch/Figure_16_1.jpg",width = 2000, height = 1600,res = 300)
print(p)
dev.off()


#--------------------------------------
# Sample level 
#--------------------------------------
# 1. Read INTERCATCH length distribution data 
IC2020LengthSamples <- read.table("boot/data/LFDs nsample intercatch/NumbersAtAgeLength.txt", sep = "\t",  header=TRUE, dec = "." , fill = TRUE, skip=2) 
IC2020LengthSamples$NumSamplesLength[IC2020LengthSamples$NumSamplesLength == -9] <- 0
IC2020LengthSamples$NumLengthMeasurements[IC2020LengthSamples$NumLengthMeasurements == -9] <- 0

TableReport1.4 <- IC2020LengthSamples %>%
  group_by(Country, Catch.Cat.) %>%
  summarise(
    NsamplesLength = sum(NumSamplesLength),
    NmeasuresLength = sum(NumLengthMeasurements),
    .groups = "drop"
  )


write.table(TableReport1.4, "data/catch/WGBIE_ReportTable1.4.csv", append=F, sep=",", row.names=F)
