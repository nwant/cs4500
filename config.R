# This file configures files and filepaths
#
# Use this file for filepath manipulation
#
get.config <- function() {
    config <- new.env()
    config$arisa.fp = "./source/ARISA.CSV"
    config$ciliates.1.fp = "./source/CILIATES_1.CSV"
    config$blur_max_error = 0.0228 # Minimum value that allows blur_rows to equal 2
    config$min_date = "2008-01-11"
    config$init_min_date = "2008-01-11"
    config$max_date = "2013-08-01"
    config$init_max_date = "2013-08-01"
    config$date_format = "yyyy-mm-dd"
    config$na_label = "-"
    return(config)
}
