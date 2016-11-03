library(shiny)
source("./config.R")
source("./data/repo.R")

# get the configuration named list and data
config <- get.config()
arisa <- get.arisa(config)

server <- function(input, output) {
  output$hist <- renderPlot({ 
    title <- "100 random normal values"
    hist(rnorm(100), main = title)
  })

  # render plot for ARISA DAT
  output$arisa_plot <- renderPlot({
    tt1_str <- if(input$tt1) "TT1" else NULL
    tt2_str <- if(input$tt2) "TT2" else NULL
    tt3_str <- if(input$tt3) "TT3" else NULL
    source_vec <- c(tt1_str, tt2_str, tt3_str)
    
    filtered <- arisa[arisa$source %in% source_vec,]
    filtered <- filtered[filtered$date >= input$date_min,]
    filtered <- filtered[filtered$date <= input$date_max,]
    filtered$X <- NULL
    filtered$source <- NULL
    filtered$date <- NULL
   
    
    
    # Render a barplot
    barplot(colSums(filtered) / nrow(filtered),
            main=paste("Relative abundance of bacteria from", paste(source_vec, collapse=","), "from", input$date_min, "to", input$date_max),
            ylab="Relative Abundance",
            xlab="Species")
    
  })
  
}
