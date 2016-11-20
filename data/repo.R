# This file returns dataframes related to the CSV's that are imported into the functions

library("plyr")

#calling should look like: dataframe <-get.name()


####[get.arisa]##########################################################################
# The get.arisa function takes in a configuration (see config.r) and creates a          #
# dataframe from the arisa CSV file.  Then that dataframe has a column for classifiyng  #
# each test-site added to it.  Next the dataframe has a column for each sample test date#
# add to it.  Finally the function returns that dataframe.                              #
#########################################################################################
get.arisa <- function(config) {
    
    # Creates a dataframe and stores all data from the arisa file into it
    arisa <- read.csv(config[["arisa.fp"]], header = TRUE)
 
    # Adds a column for classifying each testing site
    arisa$source <- substr(arisa$X, 1, 3)
    arisa$source <- gsub("TT", "T", arisa$source)
 
    # Adds a column for each sample test date
    arisa$date <- as.Date(substr(arisa$X, 5, 100), "%m_%d_%y")
 
    return(arisa)
}


####[get.ciliates.1]#####################################################################
# The get.ciliates.1 function takes in a configuration and creates a dataframe from the #
# first tab of the ciliates CSV file.  Then that dataframe removes all rows that are    #
# empty or contain invalid values.  Next the dates are converted into dates that R can  #
# use (mm-dd-yyyy) for the dataframe.  After that, the last column of the dataframe is   #
# renamed for use by R.  Finally the function returns that dataframe.                   #
#########################################################################################
get.ciliates.1 <- function(config) {
    
    # Creates a dataframe and stores all data from the first tab of the ciliates file
    ciliates.1 <- read.csv(config[["ciliates.1.fp"]], header=TRUE)

    # Remove all empty/invalid rows
    ciliates.1 <- ciliates.1[!apply(is.na(ciliates.1) | ciliates.1 == "", 1, all), ]
    
    # Convert date strings into R dates.
    ciliates.1$Date <- as.Date(gsub("/", "-", ciliates.1$Date), "%m-%d-%y")
    
    # Rename last column, which has odd characters that R can't handle
    colnames(ciliates.1)[length(ciliates.1)] <- "TotalCellsPerLiter"
    
    return(ciliates.1)
}

####[get.all]############################################################################
# The get.all function takes in a configuration file and creates a dataframe from both  #
# the arisa CSV file and the first tab of the ciliates CSV file.  Then the dataframes   #
# are labeled by their species classifications.  Next those dataframes clear out all    #
# with invalid values.  After that, the dataframes are merged together on date and test #
# site source.  Then that dataframe is cleaned once again this time looking for all     #
# N/A's.  Finally the function returns the merged dataframe.                            #
#########################################################################################
get.all <- function(config) {
    
  # Get each data set and label their species classification
  arisa <- get.arisa(config)
  ciliates.1 <- get.ciliates.1(config)
  arisa$x <- NULL
  arisa$X <- NULL
   
  # Stardardize each raw dataframe by removing unnecessary data columns and making 
  ciliates.1 <- rename(ciliates.1, c("Date" = "date", "site" = "source"))
  ciliates.1$TotalCellsPerLiter <- NULL
  ciliates.1$month <- NULL
  ciliates.1$year <- NULL
  ciliates.1$x <- NULL
  ciliates.1$X <- NULL
  
  # join using date and source
  ciliates.1$datesource <- paste(ciliates.1$date, ciliates.1$source, sep=" ")
  merged <- merge(ciliates.1, arisa, by=c("date", "source"), all =T)
 
  return(merged)
}
