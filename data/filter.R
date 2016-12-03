# This file filters dataframes by:
#
#         1. test-site
#         2. species classification
#         3. min. and max date
#

library("stringdist")

# Standard erf and its inverse (https://en.wikipedia.org/wiki/Error_function):
erf <- function(x) 2 * pnorm(x * sqrt(2)) - 1
erfinv <- function (x) qnorm((1 + x) / 2) / sqrt(2)

#====================
# filter.all.data
#-----------
# Filters Arisa and ciliates by location and time
#
# Inputs:
#   * Arisa and ciliates dataframes
#   * Minimum and maximum dates for time slice
#   * Location of the testing site
#
# Returns:
#   * Filtered dataframe with only the location and the time slice asked for
#
filter.all.data <- function(config, df, sources, date.min, date.max, species="all", only.species=FALSE) {
  time_1 <- proc.time()

  # Filter by site location (e.g. T1, T2, and/or T3)
  filtered <- df[df$source %in% sources,]

  time_2 <- proc.time()
  print("Filtering by site location:")
  print(time_2 - time_1)

  # Get appropriate data time slice
  filtered <- filtered[filtered$date >= date.min,]
  filtered <- filtered[filtered$date <= date.max,]

  time_3 <- proc.time()
  print("Filtering by time:")
  print(time_3 - time_2)

  # Remove all columns from the dataframe except the columns for requested species
  if (length(species) >= 1)
    if (stringdist(species[1], "all") != 0) { # should we be getting all species (default)?
    filtered <- filtered[colnames(filtered) %in% c(c, species, c("date", "source"), recursive=T)] # no, filter by species
  }

  if (only.species) {
    filtered$date <- NULL
    filtered$source <- NULL
  }

  time_4 <- proc.time()
  print("Filtering by species:")
  print(time_4 - time_3)

  return(filtered)
}


#============================
# get.species.names
# ---------
# Get a list of all of the ARISA and Ciliates names
#
# Inputs:
#   * The dataframe object (as in from get.all.data from repo.R)
#
# Returns:
#   * A list of all of the species names
#
get.species.names <- function(df) {
  column.names <- colnames(df)
  date.idx <- grep("date", column.names)
  column.names <- column.names[-date.idx]
  source.idx <- grep("source", column.names)
  species.names <- column.names[-source.idx]
  return(species.names)
}
