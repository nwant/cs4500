library(testthat)
source("../../data/filter.R")

sources <- c("T1", "T2", "T3")
date.min <- as.Date("01-01-2000")
date.max <- as.Date("01-02-2000")

get.mock.df <- function() {
  mock.df <- data.frame(
    c(as.Date("01-01-2000"), "T1"),
    c(as.Date("01-02-2000"), "T2")
  )
  
  colnames(mock.df) <- c("date", "source")
  
  return(mock.df)
}


test_that("testing", {
  df <- get.mock.df()
  
  df <- filter.all.data(df, c("T1"), date.min, date.max)
 
  expect_that(nrow(df), equals(2))  
})