source("./config.R")
source("./data/repo.R")
source("./data/filter.R")
source("./plot/ciliates.R")
source("./plot/arisa.R")
# get the configuration named list and data frames from csvs
library("corrplot")
library("shiny")


server <- function(input, output) {
  observeEvent(input$tt1, {
    message1 = "hello"
    cat("\nmessage recieved!")
  })
  config <- get.config()
  df <- get.all(config)
  species <- get.species.names(df)
  
   outVar <- reactive({
     selected.species <- all.vars(parse(text = input$species))
     selected.species <- as.list(selected.species)
     return (selected.species)
   })
  
  output$speciesSelect <- renderUI({
    selectInput("species", "Species", species, multiple = TRUE)
  })
  
  output$corr_matrix <- renderPlot({
    
    tt1 <- if(input$tt1) "T1" else NULL
    tt2 <- if(input$tt2) "T2" else NULL
    tt3 <- if(input$tt3) "T3" else NULL
    sources <- c(tt1, tt2, tt3)
   
    date.min <- as.Date(input$date_min)
    date.max <- as.Date(input$date_max)

    f <- filter.all.data(config, df, sources, date.min, date.max, species = input$species, only.species = T)
    M <- cor(f)
    p <- corrplot.mixed(M)
    return(p)
  })

}


  
  
