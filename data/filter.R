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
filter.all.data <- function(config, df, sources, date.min, date.max, blur=1, species="all", only.species=FALSE) {
  time_1 <- proc.time()

  # Calculate number of rows above and below each row needed to get the blur error below the config value.
  # This is the inverse gaussian function (https://en.wikipedia.org/wiki/Normal_distribution#Quantile_function)
  blur_rows <- blur * sqrt(2) * erfinv(2 * config$blur_max_error - 1)
  blur_rows <- ceiling(abs(blur_rows))

  x_factor <- 1 / (sqrt(2) * blur)
  gauss_cum <- function(x) 0.5 * (1 + erf(x * x_factor))
  stopifnot(gauss_cum(-blur_rows) <= config$blur_max_error)

  gauss_window <- function(x) gauss_cum(x + 0.5) - gauss_cum(x - 0.5)
  gauss_factor <- cbind(gauss_window(-blur_rows:blur_rows))

  col_date = df[, "date"]
  col_source = df[, "source"]
  df <- df[, -(1:2)]

  zero = df[1,] * 0
  shift_up <- function(k) rbind(tail(df, -k), zero[rep(1, k), ])
  shift_down <- function(k) rbind(zero[rep(1, k), ], head(df, -k))

  time_2 <- proc.time()
  print("Setup:")
  print(time_2 - time_1)

  ups = Reduce('+', lapply(1:blur_rows, function(x) shift_up(x) * gauss_window(x)))
  center = df * gauss_window(0)
  downs = Reduce('+', lapply(1:blur_rows, function(x) shift_down(x) * gauss_window(x)))

  time_3 <- proc.time()
  print("Blur reduction:")
  print(time_3 - time_2)

  df <- ups + center + downs
  df <- cbind(date = col_date, source = col_source, df)

  time_4 <- proc.time()
  print("Blur concatenation:")
  print(time_4 - time_3)

  # Filter by site location (e.g. T1, T2, and/or T3)
  filtered <- df[df$source %in% sources,]

  time_5 <- proc.time()
  print("Filtering by site location:")
  print(time_5 - time_4)

  # Get appropriate data time slice
  filtered <- filtered[filtered$date >= date.min,]
  filtered <- filtered[filtered$date <= date.max,]

  time_6 <- proc.time()
  print("Filtering by time:")
  print(time_6 - time_5)

  # Remove all columns from the dataframe except the columns for requested species
  if (length(species) >= 1)
    if (stringdist(species[1], "all") != 0) { # should we be getting all species (default)?
    filtered <- filtered[colnames(filtered) %in% c(c, species, c("date", "source"), recursive=T)] # no, filter by species
  }

  if (only.species) {
    filtered$date <- NULL
    filtered$source <- NULL
  }

  time_7 <- proc.time()
  print("Filtering by species:")
  print(time_7 - time_6)

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
