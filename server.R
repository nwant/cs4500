source("./config.R")
source("./data/repo.R")
source("./data/filter.R")
source("./plot/ciliates.R")
source("./plot/arisa.R")
# get the configuration named list and data frames from csvs
library("corrplot")
library("shiny")


server <- function(input, output) {
  config <- get.config()
  df <- get.all(config)
  species <- get.species.names(df)

  output$species <- renderUI({
    selectInput("species", "Choose Species:", as.list(c("test")))
  })
  
  output$selection <- renderPlot(
    input$specieschooser
  )
  
  output$corr_matrix <- renderPlot({
    
    tt1 <- if(input$tt1) "TT1" else NULL
    tt2 <- if(input$tt2) "TT2" else NULL
    tt3 <- if(input$tt3) "TT3" else NULL
    sources <- c(tt1, tt2, tt3)
    date.min <- input$date_min
    date.max <- input$date_max
    
    #hist(c(1,2,3))

     f <- filter.all.data(config, df, sources, date.min, date.max, species = c("Colpodida", "Cyrtophorida"))
     M <- cor(f)
     corrplot(M, method="circle")
    
  })

}


  
  
