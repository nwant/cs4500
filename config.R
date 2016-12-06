# This file configures files and filepaths
#
# Use this file for filepath manipulation
#
get.config <- function() {
    config <- new.env()
    config$arisa.fp = "./source/ARISA.CSV"            # (relative) filepath for ASISA data
    config$ciliates.1.fp = "./source/CILIATES_1.CSV"  # (relative) filepath for Ciliates data 
    config$blur_max_error = 0.0000317                 # Minimum value that allows blur_rows to equal 4
    config$min_date = "2008-01-11"                    # earlist date allowed for Start Date
    config$init_min_date = "2008-01-11"               # default date for Start Date
    config$max_date = "2013-08-01"                    # lastest date allowed for End Date
    config$init_max_date = "2013-08-01"               # default date for End Date
    config$date_format = "yyyy-mm-dd"                 # date format for all dates in UI (i.e. Start and End Date)
    config$na_label = "-"                             # symbol used whenever a N/A value appears in correlation matrix
    config$show_main_diag = FALSE                     # whether or not to show the main diagonal (species compared w/ itself) in the corrlation matrix
    config$init_species_count = 2                     # the number of species to have the application select by default (only upon loading)
    return(config)
}
