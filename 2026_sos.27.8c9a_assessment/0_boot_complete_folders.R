library(icesTAF)

# We can check the information available at: https://github.com/ices-taf/doc/wiki/Example-datasets-1
# Create a empty project

taf.skeleton() #create structure in the project folder

# Data -------------------------------------------------------------------------
# Move data files to the initial/data folder

#draft.data() # create a empty entry for data. 
#?draft.data  # The help pages are more completed in the TAF package.

assessment_year<-2025

# Create the associated data.bib
# IMPORTANT: When using draft.data() multiple times, make sure to set `append = TRUE` for all entries after the first one.
# Only the first call should omit `append` or set it to FALSE to avoid overwriting data.bib.
# Also, be careful with long titles—use paste() to avoid issues with line breaks.
# If entries are missing in data.bib, taf.boot() will only copy the folders listed there.

draft.data(
  data.files = "Catches",
  originator = "intercatch",
  year = assessment_year,
  title = "Catch data after formatting WKWEST benchmark (2009-2024) plus catch (intercatch) 2025",
  file = TRUE,
  append = FALSE)


draft.data(
  data.files = "Effort",
  originator = "WGBIE",
  year = assessment_year,
  period = "2011-2025",
  title = paste("Portuguese fleet effort (2011–2025)"),
  file = TRUE,
  append = TRUE)

draft.data(
  data.files = "LFDs nsample intercatch",
  originator = "intercatch",
  year = assessment_year,
  period = "2025",
  title = "LFD (Length Frequency Distribution) Number of samples (NSample) for 2025",
  file = TRUE,
  append = TRUE)

taf.boot() # Create the data folder in boot with all the files


