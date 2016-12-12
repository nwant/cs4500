# ====================
# test.blur.R
# --------------
#
# test file for testing functions found in blur
#

library(testthat)
source("../../config.R")
source("../../data/blur.R")

#--------------------------
# get.mock.df
#-------------
# helper function that returns a mock dataframe reminiscent of the dataframe returned by
# get.all (see data/repo.R).
#1
# Returns: the mock dataframe reminiscient of the data frame returned by get.all
#
get.mock.df <- function() {

  dates <- as.Date(c("2000-01-02", "2000-02-02", "2015-02-05", "2016-11-20", "2014-2-2", "2013-9-9"))
  sources <- c("T1", "T2", "T3", "T1", "T2", "T3")
  species1 <- c(0, 0, 0.5, 0, 0, 0)
  species2 <- c(0, 0.1, 0.2, 0, 0, 0.5)
  mock.df <- data.frame(dates, sources, species1, species2)

  colnames(mock.df) <- c(c("date", "source"), species, recursive=T)

  return(mock.df)
}


#------filter.all.data tests-----------

#------filter by test site-------------
context("blur")

# Creates a df from the mock data with only the TT1 test site and
# filters it to assure that the filter function works for dividing
# by specific test sites
test_that("filter.blur blurs the data", {
  config <- get.config()
  df <- get.mock.df()
  b <- filter.blur(config, df, 0.1)
})
