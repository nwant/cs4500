source("./config.R")
source("./data/repo.R")
source("./data/filter.R")
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
    selectInput("species", "Species", species, multiple = TRUE, selected=species[0:2])
    
  })
  
  # initialize species to include at least 2 species
  output$corr_matrix <- renderPlot({
    
    tt1 <- if(input$tt1) "T1" else NULL
    tt2 <- if(input$tt2) "T2" else NULL
    tt3 <- if(input$tt3) "T3" else NULL
    sources <- c(tt1, tt2, tt3)
   
    date.min <- as.Date(input$date_min)
    date.max <- as.Date(input$date_max)
    
    # set server side validation
    validate(
      need(length(input$species) >= 2, "You must select at least 2 species!"), # corrlation matrix will only work with at least 2 species to compare 
      need(input$tt1 | input$tt2 | input$tt3, "At least one site must be selected!"), # one site must always be selected or # of rows in dataframe would be 0.
      need(date.min <= date.max, "The minimum date must be less than the maximum date selected") 
    )

    f <- filter.all.data(config, df, sources, date.min, date.max, species = input$species, only.species = T)
    M <- cor(f)
    p <- corrplot(M, order="alphabet")
    return(p)
  })
}


  
  
