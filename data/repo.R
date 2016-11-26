#------------------------------
# repo.R
# This file returns dataframes related to the CSV's that are imported into the functions
##############################################################################################
library("plyr")
library("zoo")

#============================
# get.arisa
# ---------
# get a dataframe containing data from the ARISA dataset
#
# Inputs:
#   config...a configuration object
#
# Returns:
#   a dataframe containing data from the ARISA dataset
#   Rows correspond to a single date from which samples were taken.
#   Columns include a formated date (date), site location (source),
#   and the each species of ARISA with its corresponding relative abundance
#   determined for each corresponding date/site.
get.arisa <- function(config) {

    # Creates a dataframe and stores all data from the arisa file into it
    arisa <- read.csv(config$arisa.fp, header = TRUE)

    # Adds a column for classifying each testing site
    arisa$source <- substr(arisa$X, 1, 3)
    arisa$source <- gsub("TT", "T", arisa$source)

    # Adds a column for each sample test date
    arisa$date <- as.Date(substr(arisa$X, 5, 100), "%m_%d_%y")

    return(arisa)
}


#============================
# get.ciliates.1
# ---------
# get a dataframe containing data from the Ciliates (tab 1) dataset
#
# Inputs:
#   config...a configuration object
#
# Returns:
#   a dataframe containing data from the Ciliates (tab 1) dataset.
#   Rows correspond to a single date from which samples were taken.
#   Columns include a formated date (date), site location (source),
#   total cells per litter obtained (TotalCellsPerLiter), and columns for each Ciliate species,
#   of which contain the cells per litter for each species taken at a specific date
get.ciliates.1 <- function(config) {

    # Creates a dataframe and stores all data from the first tab of the ciliates file
    ciliates.1 <- read.csv(config$ciliates.1.fp, header=TRUE)

    # Remove all empty/invalid rows
    ciliates.1 <- ciliates.1[!apply(is.na(ciliates.1) | ciliates.1 == "", 1, all), ]

    # Convert date strings into R dates.
    ciliates.1$Date <- as.Date(gsub("/", "-", ciliates.1$Date), "%m-%d-%y")

    # Rename last column, which has odd characters that R can't handle
    colnames(ciliates.1)[length(ciliates.1)] <- "TotalCellsPerLiter"

    return(ciliates.1)
}



#============================
# get.all
# ---------
# get a combined dataframe containing data from both ARISA the Ciliates (tab 1) datasets
#
# Inputs:
#   config...a configuration object
#
# Returns:
#   a dataframe containing data from the Ciliates (tab 1) dataset.
#   Rows correspond to a single date from which samples were taken.
#   Columns include a formated date (date), site location (source),
#   and columns for each Ciliate species, of which contain the cells
#   per litter for each species taken at a specific date, and the each
#   species of ARISA with its corresponding relative abundance determined
#   for each corresponding date/site.
get.all <- function(config) {
  rename.column <- function(df, old.name, new.name) {
    cloned.df <- data.frame(df)
    idx <- grep(old.name, colnames(df))
    colnames(cloned.df)[idx] <- new.name
    return(cloned.df)    
  }
  
  # Get each data set and label their species classification
  arisa <- get.arisa(config)
  ciliates.1 <- get.ciliates.1(config)
  arisa$X <- NULL

  # Stardardize each raw dataframe by removing unnecessary data columns and making
  ciliates.1 <- rename.column(ciliates.1, "Date", "date")
  ciliates.1 <- rename.column(ciliates.1, "site", "source")
   
  ciliates.1$TotalCellsPerLiter <- NULL
  ciliates.1$month <- NULL
  ciliates.1$year <- NULL
  ciliates.1$X <- NULL

  # join using date and source
  merged <- merge(ciliates.1, arisa, by=c("date", "source"), all = T)

  # Interpolate NA values
  #merged <- na.approx(merged)

  return(merged)
}
