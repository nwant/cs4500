# This file configures files and filepaths 
#
# Use this file for filepath manipulation
#
get.config <- function() {
    config <- new.env()
    config$R.repos = "http://cran.us.r-project.org"
    config$arisa.fp = "./source/ARISA.CSV"
    config$ciliates.1.fp = "./source/CILIATES_1.CSV"
    config$ciliates.2.fp = "./source/CILIATES_2.CSV"
    config$blur_max_error = 0.001
    return(config)
}
