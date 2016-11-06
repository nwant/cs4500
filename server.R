source("./config.R")
source("./data/repo.R")
source("./plot/ciliates.R")
source("./plot/arisa.R")
# get the configuration named list and data frames from csvs
config <- get.config()

library(shiny)

arisa <- get.arisa(config)
ciliates.1 <- get.ciliates.1(config)

server <- function(input, output) {

  # render plot for ARISA data
  output$arisa_plot <- renderPlot({
    tt1 <- if(input$tt1) "TT1" else NULL
    tt2 <- if(input$tt2) "TT2" else NULL
    tt3 <- if(input$tt3) "TT3" else NULL
    sources <- c(tt1, tt2, tt3)
    date.min <- input$date_min
    date.max <- input$date_max
    
    p <- render.arisa.plot(arisa, sources, date.min, date.max)
    print(p)
  })
  
  output$ciliates_plot <- renderPlot({
    tt1 <- if(input$tt1) "T1" else NULL
    tt2 <- if(input$tt2) "T2" else NULL
    tt3 <- if(input$tt3) "T3" else NULL
    sources <- c(tt1, tt2, tt3)
    date.min <- input$date_min
    date.max <- input$date_max
    # 
    p <- render.ciliates.plot(ciliates.1, sources, date.min, date.max)
    print(p)
  })
}


  
  
