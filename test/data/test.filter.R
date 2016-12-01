# ====================
# test.filter.R
# --------------
#
# test file for testing functions found in filter
#

library(testthat)
source("../../config.R")
source("../../data/filter.R")

sources <- c("T1", "T2", "T3")          # the complete list of sources in the mock dataframe
date.min <- as.Date("2000-01-02")       # the earliest date that appears in the mock dataframe
date.max <- as.Date("2016-11-20")       # the most recent date that appears in the mock dataframe
species <- c("Colopodida", "Cyrtophorida")

#--------------------------
# get.mock.df
#-------------
# helper function that returns a mock dataframe reminiscent of the dataframe returned by
# get.all (see data/repo.R).
#
# Returns: the mock dataframe reminiscient of the data frame returned by get.all
#
get.mock.df <- function() {

  dates <- as.Date(c("2000-01-02", "2000-02-02", "2015-02-05", "2016-11-20", "2014-2-2", "2013-9-9"))
  sources <- c("T1", "T2", "T3", "T1", "T2", "T3")
  species1 <- c(2, 3, 4, 5, 6, 7)
  species2 <- c(.3, 0, .4, .5, .32, .12)
  mock.df <- data.frame(dates, sources, species1, species2)

  colnames(mock.df) <- c(c("date", "source"), species, recursive=T)

  return(mock.df)
}


#------filter.all.data tests-----------

#------filter by test site-------------
context("filter by source")

# Creates a df from the mock data with only the TT1 test site and
# filters it to assure that the filter function works for dividing
# by specific test sites
test_that("filter.all.data filters sites for site T1", {
  config <- get.config()
  df <- get.mock.df()
  f <- filter.all.data(config, df, c("T1"), date.min, date.max)
  expect_equivalent(f$source, df$source[df$source == "T1"])
})

# Creates a df from the mock data with only the TT2 test site and
# filters it to assure that the filter function works for dividing
# by specific test sites
test_that("filter.all.data filters sites for site T2", {
  config <- get.config()
  df <- get.mock.df()
  f <- filter.all.data(config, df, c("T2"), date.min, date.max)
  expect_equivalent(f$source, df$source[df$source == "T2"])
})

# Creates a df from the mock data with only the TT3 test site and
# filters it to assure that the filter function works for dividing
# by specific test sites
test_that("filter.all.data filters sites for site T3", {
  config <- get.config()
  df <- get.mock.df()
  f <- filter.all.data(config, df, c("T3"), date.min, date.max)
  expect_equivalent(f$source, df$source[df$source == "T3"])
})

# Creates a df from the mock data from TT1 & TT2 test sites and
# filters it to assure that the filter function works for dividing
# into multiple test sites
test_that("filter.all.data filters by sites for T1 or T2", {
  config <- get.config()
  df <- get.mock.df()
  f <- filter.all.data(config, df, c("T1", "T2"), date.min, date.max)
  expect_equivalent(f$source, df$source[df$source == "T1" | df$source == "T2"])
})

# Creates a df from the mock data from TT2 & TT3 test sites and
# filters it to assure that the filter function works for dividing
# into multiple test sites
test_that("filter.all.data filters by sites for T2 or T3", {
  config <- get.config()
  df <- get.mock.df()
  f <- filter.all.data(config, df, c("T2", "T3"), date.min, date.max)
  expect_equivalent(f$source, df$source[df$source == "T2" | df$source == "T3"])
})

# Creates a df from the mock data from TT1 & TT3 test sites and
# filters it to assure that the filter function works for dividing
# into multiple test sites
test_that("filter.all.data gets all for site T1 or T3", {
  config <- get.config()
  df <- get.mock.df()
  f <- filter.all.data(config, df, c("T1", "T3"), date.min, date.max)
  expect_equivalent(f$source, df$source[df$source == "T1" | df$source == "T3"])
})

# Creates a df from the mock data from all test sites and
# filters it to assure that the filter function works for
# including all test sites
test_that("filter.all.data filters by site T1, T2, or T3", {
  config <- get.config()
  df <- get.mock.df()
  f <- filter.all.data(config, df, c("T1", "T2", "T3"), date.min, date.max)
  expect_equivalent(f$source, df$source[df$source == "T1" | df$source == "T2" | df$source == "T3"])
})


#------filter by date--------
context("filter by date")

# Creates a df from the mock data from the dates inputed by the user
test_that("filter.all.data filters", {
  config <- get.config()
  df <- get.mock.df()
  f <- filter.all.data(config, df, sources, date.min, date.max)
  expect_equivalent(f$date, df$date[df$date >= date.min & df$date <= date.max])
})

#------filter by species-------
context("filter by species")

test_that("filter.all.data provides all species when species is set to 'all'", {
  config <- get.config()
  df <- get.mock.df()
  f <- filter.all.data(config, df, sources, date.min, date.max, species = "all")
  expect_equivalent(colnames(df), colnames(f))
})

test_that("filter.all.data filters by species", {
  config <- get.config()
  df <- get.mock.df()
  f <- filter.all.data(config, df, sources, date.min, date.max, species=c("Colopodida"))
  expect_equivalent(c("date", "source", "Colopodida"), colnames(f))
})

context("only getting species data")

test_that("filter.all.data removes date and source columns when only.species is true", {
  config <- get.config()
  df <- get.mock.df()
  f <- filter.all.data(config, df, sources, date.min, date.max, only.species = T)
  expect_equivalent(species, colnames(f))
})
