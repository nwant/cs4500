# This File produces the shiny app for UI
library(shiny)

ui <- bootstrapPage(
  fluidPage(
    
    sidebarPanel(
      # Inputs for testing sites
      uiOutput("speciesSelect"), 
      checkboxInput(inputId = "tt1", label = strong("Show T1"), value = TRUE),
       
      checkboxInput(inputId = "tt2", label = strong("Show T2"), value = TRUE),
       
      checkboxInput(inputId = "tt3", label = strong("Show T3"), value = TRUE),
  
      # Inputs for time-slice (Date min & max)
      dateInput(inputId = "date_min", "Date Start", value = "2008-01-11", 
                 min = "2008-01-11", max = "2013-08-01",format = "yyyy-mm-dd", 
                 startview = "month", weekstart = 0, language = "en", width = NULL),
       
      dateInput(inputId = "date_max", "Date End", value = "2013-08-01", 
                 min = "2008-01-11", max = "2013-08-01", format = "yyyy-mm-dd", 
                 startview = "month", weekstart = 0, language = "en", width = NULL)
    ),mainPanel(
      # Puts the corr matrix onto the UI
      plotOutput("corr_matrix")
    )
  )
)
