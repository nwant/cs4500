# This File produces the shiny app for UI
source("./config.R")
library(shiny)

config <- get.config()

ui <- bootstrapPage(
  config <- 
  fluidPage(
    sidebarPanel(
      # Inputs for testing sites
      uiOutput("speciesSelect"), 
      checkboxInput(inputId = "tt1", label = strong("Show T1"), value = TRUE),
      checkboxInput(inputId = "tt2", label = strong("Show T2"), value = TRUE),
       
      checkboxInput(inputId = "tt3", label = strong("Show T3"), value = TRUE),
  
      # Inputs for time-slice (Date min & max)
      dateInput(inputId = "date_min", "Date Start", value = config$init_min_date, 
                 min = config$min_date, max = config$max_date,format = config$date_format, 
                 startview = "month", weekstart = 0, language = "en", width = NULL),
       
      dateInput(inputId = "date_max", "Date End", value = config$init_max_date, 
                 min = config$min_date, max = config$max_date, format = config$date_format, 
                 startview = "month", weekstart = 0, language = "en", width = NULL)
    ),mainPanel(
      # Puts the corr matrix onto the UI
      plotOutput("corr_matrix")
    )
  )
)
