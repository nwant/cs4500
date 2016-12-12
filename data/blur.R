# Standard erf and its inverse (https://en.wikipedia.org/wiki/Error_function):
erf <- function(x) 2 * pnorm(x * sqrt(2)) - 1
erfinv <- function (x) qnorm((1 + x) / 2) / sqrt(2)

cache <- new.env()

filter.blur <- function(config, df, blur) {
  if (blur > 0.001) {
    # Try to find the blur factor in the cache
    index <- as.character(blur)
    if (exists(index, cache, inherits=FALSE)) {
      # If it's in the cache, return it.
      return(cache[[index]])
    }

    time_1 <- proc.time()

    # Calculate number of rows above and below each row needed to get the blur error below the config value.
    # This is the inverse gaussian function (https://en.wikipedia.org/wiki/Normal_distribution#Quantile_function)
    blur_rows <- blur * sqrt(2) * erfinv(2 * config$blur_max_error - 1)
    blur_rows <- ceiling(abs(blur_rows))

    # Define the normal cumulative distribution function:
    # https://en.wikipedia.org/wiki/Normal_distribution#Cumulative_distribution_function
    x_factor <- 1 / (sqrt(2) * blur)
    gauss_cum <- function(x) 0.5 * (1 + erf(x * x_factor))

    # Make sure the cumulative value below and above the blur_rows is less than the maximum error.
    stopifnot(gauss_cum(-blur_rows) <= config$blur_max_error)

    # Define the normal distribution window function.
    # Returns the area of a 1-unit wide slice, centered on x.
    gauss_window <- function(x) gauss_cum(x + 0.5) - gauss_cum(x - 0.5)

    # Remove the non-numerical columns
    col_date = df[, "date"]
    col_source = df[, "source"]
    df <- df[, -(1:2)]

    # Make a zero-row, for use in appending and prepending onto shifted data frames
    zero = df[1,] * 0

    # Define functions to shift the data frame up and down by a number of rows
    shift_up <- function(k) rbind(tail(df, -k), zero[rep(1, k), ])
    shift_down <- function(k) rbind(zero[rep(1, k), ], head(df, -k))

    time_2 <- proc.time()
    print("Setup:")
    print(time_2 - time_1)

    # Shift rows up, multiply them by the window function, and add them together
    ups = Reduce('+', lapply(1:blur_rows, function(x) shift_up(x) * gauss_window(x)))
    center = df * gauss_window(0)
    downs = Reduce('+', lapply(1:blur_rows, function(x) shift_down(x) * gauss_window(x)))

    time_3 <- proc.time()
    print("Blur reduction:")
    print(time_3 - time_2)

    # Add the result together
    df <- ups + center + downs

    # Add the textual columns
    df <- cbind(date = col_date, source = col_source, df)

    time_4 <- proc.time()
    print("Blur concatenation:")
    print(time_4 - time_3)

    # Store the blurred dataframe into the cache
    cache[[index]] <- df
  }

  return(df)
}
