# This file filters dataframes by:
#         1. test-site
#         2. species classification
#         3. min. and max date

#Calling should look like: ???


# Standard erf and its inverse (https://en.wikipedia.org/wiki/Error_function):
erf <- function(x) 2 * pnorm(x * sqrt(2)) - 1
erfinv <- function (x) qnorm((1 + x) / 2) / sqrt(2)


####[filter.all.data]##############################################################################
# This function takes in (a dataframe, a test-ste, a species classification, minimum and maximum  #
# for dates) as parameters.  Then it filters the dataframe by test-site.  Next that dataframe is  #
# filtered by filtered by species classification.  After that, the dataframe is filtered by the   #
# time-slice in-between the min. date and max. date.  Next that dataframe has all unnessecary     #
# columns removed.  Finally that dateframe is returned.                                           #
###################################################################################################
filter.all.data <- function(config, df, sources, date.min, date.max, blur=1, species="all") {
  # Calculate number of rows above and below each row needed to get the blur error below the config value.
  # This is the inverse gaussian function (https://en.wikipedia.org/wiki/Normal_distribution#Quantile_function)
  blur_rows <- blur * sqrt(2) * erfinv(2 * config$blur_max_error - 1)
  blur_rows <- ceiling(abs(blur_rows))

  x_factor <- 1 / (sqrt(2) * blur)
  gauss_cum <- function(x) 0.5 * (1 + erf(x * x_factor))
  stopifnot(gauss_cum(-blur_rows) <= config$blur_max_error)

  gauss_window <- function(x) gauss_cum(x + 0.5) - gauss_cum(x - 0.5)

  # Run function over each row of data.
  df <- t(sapply(1:nrow(df), function(i) {
    res <- df[i,] * gauss_window(0)
    for (j in 1:blur_rows) {
      if (i - j > 0) {
        res <- res + df[i - j,] * gauss_window(-j)
      }
      if (i + j <= nrow(df)) {
        res <- res + df[i + j,] * gauss_window(j)
      }
    }
    res
  }))

  # Filter by site location (e.g. T1, T2, and/or T3)
  filtered <- df[df$source %in% sources,]

  # Get appropriate data time slice
  filtered <- filtered[filtered$date >= date.min,]
  filtered <- filtered[filtered$date <= date.max,]

  # Remove all columns from the dataframe except the columns for requested species
  if (grepl(species, "all")) {
    filtered.date <- NULL
    filtered.source <- NULL
  } else {
    filtered <- filtered[colnames(filtered) %in% species]
  }

  return(filtered)
}
