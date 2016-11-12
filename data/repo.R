library("plyr")

get.arisa <- function(config) {
    arisa <- read.csv(config[["arisa.fp"]], header = TRUE)
 
    # add column for classifying each testing site
    arisa$source <- substr(arisa$X, 1, 3)
    arisa$source <- gsub("TT", "T", arisa$source)
 
    # add column for each sample test date
    arisa$date <- as.Date(substr(arisa$X, 5, 100), "%m_%d_%y")
 
    return(arisa)
}

get.ciliates.1 <- function(config) {
    ciliates.1 <- read.csv(config[["ciliates.1.fp"]], header=TRUE)

    # remove all empty/invalid rows
    ciliates.1 <- ciliates.1[!apply(is.na(ciliates.1) | ciliates.1 == "", 1, all), ]
    
    # convert date strings into R dates.
    ciliates.1$Date <- as.Date(gsub("/", "-", ciliates.1$Date), "%m-%d-%y")
    
    # rename last column, which has odd characters that R can't handle
    colnames(ciliates.1)[length(ciliates.1)] <- "TotalCellsPerLiter"
    
    return(ciliates.1)
}

get.all <- function(config) {
  arisa <- get.arisa(config)
  ciliates.1 <- get.ciliates.1(config)
  
  # stardardize each raw dataframe by removing unnecessary data columns and making 
  ciliates.1 <- rename(ciliates.1, c("Date" = "date", "site" = "source"))
  ciliates.1$TotalCellsPerLiter <- NULL
  ciliates.1$month <- NULL
  ciliates.1$year <- NULL
  ciliates.1$X <- NULL
  
  ciliates.1$datesource <- paste(ciliates.1$date, ciliates.1$source, sep=" ")
  arisa$datesource <- paste(arisa$date, arisa$source, sep=" ")
  
  # merge on date
  merged.by.date <- merge(ciliates.1, arisa, by="datesource", all =T)
  
  return(merged.by.date)
}