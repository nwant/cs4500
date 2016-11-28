source("./controls.R")
source("./config.R")
source("./data/repo.R")
source("./data/filter.R")
library(shiny)

config <- get.config()
df <- get.all(config)
species <- get.species.names(df)
df <- NULL

ui <- bootstrapPage(
  includeScript("www/handlers.js"),
  fluidPage(
    fluidRow(
      column(6, 
             #selectInput("speciesSelect", "Species", species, multiple = TRUE)),
             uiOutput("speciesSelect")), 
      column(3, 
             checkboxInput(inputId = "tt1", label = strong("Show T1"), value = TRUE),

             checkboxInput(inputId = "tt2", label = strong("Show T2"), value = TRUE),

             checkboxInput(inputId = "tt3", label = strong("Show T3"), value = TRUE)),
      
      column(3,
             dateInput(inputId = "date_min", "Date Start", value = "2008-01-11", 
                       min = "2008-01-11", max = "2013-08-01",format = "yyyy-mm-dd", 
                       startview = "month", weekstart = 0, language = "en", width = NULL),
             
             dateInput(inputId = "date_max", "Date End", value = "2013-08-01", 
                       min = "2008-01-11", max = "2013-08-01", format = "yyyy-mm-dd", 
                       startview = "month", weekstart = 0, language = "en", width = NULL))
    ),
    
    fluidRow(
      plotOutput("corr_matrix")
    )
    )
    
)
