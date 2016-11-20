library(testthat)
source("../../data/filter.R")

sources <- c("T1", "T2", "T3")
date.min <- as.Date("2000-01-02")
date.max <- as.Date("2016-11-20")


#--------------------------
# get.mock.df
#-------------
# helper function that returns a mock dataframe reminiscent of the dataframe returned by
# get.all (see data/repo.R).
#
# Returns: the mock dataframe reminiscient of the data frame returned by get.all
get.mock.df <- function() {
  dates <- as.Date(c("2000-01-02", "2000-02-02", "2015-02-05", "2016-11-20", "2014-2-2", "2013-9-9"))
  sources <- c("T1", "T2", "T3", "T1", "T2", "T3")
  mock.df <- data.frame(dates, sources)
  
  colnames(mock.df) <- c("date", "source")
  
  return(mock.df)
}


#------filter.all.data tests-----------

context("filter by source")

run.source.test <- function(sources, expectation) {
  df <- get.mock.df()
  f <- filter.all.data(df, sources, date.min, date.max)
  expect_equivalent(f$source, df$source[expectation])
}

test_that("filter.all.data filters sites for site T1", {
  run.source.test(
    sources = c("T1"), 
    expectation = df$source == "T1")
})

test_that("filter.all.data filters sites for site T2", {
  run.source.test(
    sources = c("T2"), 
    expectation = df$source == "T2")
})

test_that("filter.all.data filters sites for site T3", {
  run.source.test(
    sources = c("T3"), 
    expectation = df$source == "T3")
})

test_that("filter.all.data filters by sites for T1 or T2", {
  run.source.test(
    sources = c("T1", "T2"),
    expectation = df$source == "T1" | df$source == "T2")
})

test_that("filter.all.data filters by sites for T2 or T3", {
  run.source.test(
    sources = c("T2", "T3"),
    expectation = df$source == "T2" | df$source == "T3")
})

test_that("filter.all.data gets all for site T1 or T3", {
  run.source.test(
    sources = c("T1", "T3"),
    expectation = df$source == "T1" | df$source == "T3")
})

test_that("filter.all.data filters by site T1, T2, or T3", {
  run.source.test(
    sources = c("T1", "T2", "T3"),
    expectation = df$source == "T1" | df$source == "T2" | df$source == "T3")
})


context("filter by date")

