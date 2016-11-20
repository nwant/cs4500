library(testthat)
source("../../data/filter.R")

sources <- c("T1", "T2", "T3")
date.min <- as.Date("2000-01-02")
date.max <- as.Date("2016-11-20")


get.mock.df <- function() {
  dates <- as.Date(c("2000-01-02", "2000-02-02", "2015-02-05", "2016-11-20", "2014-2-2", "2013-9-9"))
  sources <- c("T1", "T2", "T3", "T1", "T2", "T3")
  mock.df <- data.frame(dates, sources)
  
  colnames(mock.df) <- c("date", "source")
  
  return(mock.df)
}


test_that("testing", {
  df <- get.mock.df()
  
  df <- filter.all.data(df, c("T1"), date.min, date.max)
 
  expect_that(nrow(df), equals(2))  
})