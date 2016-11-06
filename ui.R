source('./config.R')
config <- get.config()

if (!require(shiny)) {
  install.packages("shiny", quiet=TRUE, repos=config['R.repos'], dependencies=TRUE)
}
library(shiny)


ui <- pageWithSidebar(
  
  # Application title
  headerPanel("SidePanel"),
  
  # Sidebar with controls to select the variable to plot against mpg
  # and to specify whether outliers should be included
  sidebarPanel(
  
    checkboxInput(inputId = "tt1",
      label = strong("Show TT1"),
      value = TRUE),
      
    checkboxInput(inputId = "tt2",
      label = strong("Show TT2"),
      value = TRUE),
      
    checkboxInput(inputId = "tt3",
      label = strong("Show TT3"),
      value = TRUE),
      
    dateInput(inputId = "date_min", "Date Start", value = "2008-01-11", min = "2008-01-11", max = "2013-08-01",
      format = "yyyy-mm-dd", startview = "month", weekstart = 0,
      language = "en", width = NULL),
      
    dateInput(inputId = "date_max", "Date End", value = "2013-08-01", min = "2008-01-11", max = "2013-08-01",
      format = "yyyy-mm-dd", startview = "month", weekstart = 0,
      language = "en", width = NULL)

  ),
  mainPanel(
    plotOutput("arisa_plot"),
    plotOutput("ciliates_plot")
  )
)
