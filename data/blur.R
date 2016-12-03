# Standard erf and its inverse (https://en.wikipedia.org/wiki/Error_function):
erf <- function(x) 2 * pnorm(x * sqrt(2)) - 1
erfinv <- function (x) qnorm((1 + x) / 2) / sqrt(2)

cache <- new.env()

filter.blur <- function(config, df, blur) {
  if (blur > 0.001) {
    index <- as.character(blur)
    if (exists(index, cache, inherits=FALSE)) {
      return(cache[[index]])
    }

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

    print(dim(df))

    cache[[index]] <- df
  }

  return(df)
}
