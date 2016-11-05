#install.packages("ggplot2")
#require(ggplot2)
library(shiny)
library(ggplot2)
source("./config.R")
source("./data/repo.R")

# get the configuration named list and data frames from csvs
config <- get.config()
arisa <- get.arisa(config)
ciliates.1 <- get.ciliates.1(config)

server <- function(input, output) {

  # render plot for ARISA data
  output$arisa_plot <- renderPlot({
    tt1 <- if(input$tt1) "TT1" else NULL
    tt2 <- if(input$tt2) "TT2" else NULL
    tt3 <- if(input$tt3) "TT3" else NULL
    sources <- c(tt1, tt2, tt3)
    
    filtered <- arisa[arisa$source %in% sources,]
    filtered <- filtered[filtered$date >= input$date_min,]
    filtered <- filtered[filtered$date <= input$date_max,]
    filtered$X <- NULL
    filtered$source <- NULL
    filtered$date <- NULL
    
    # Render a barplot
    barplot(colSums(filtered) / nrow(filtered),
            main=paste("Relative abundance of bacteria from", paste(sources, collapse=","), "from", input$date_min, "to", input$date_max),
            ylab="Relative Abundance",
            xlab="Species")
  })
  
  output$ciliates_plot <- renderPlot({
    
    tt1 <- if(input$tt1) "T1" else NULL
    tt2 <- if(input$tt2) "T2" else NULL
    tt3 <- if(input$tt3) "T3" else NULL
    sources <- c(tt1, tt2, tt3)
    
    filtered <- ciliates.1[ciliates.1$site %in% sources,]
    filtered <- filtered[filtered$Date >= input$date_min,]
    filtered <- filtered[filtered$Date <= input$date_max,]
    filtered$month <- NULL
    filtered$year <- NULL
    filtered$site <- NULL
    filtered$Date <- NULL
    filtered$X <- NULL
    filtered$TotalCellsPerLiter <- NULL
    
    filtered <- colSums(filtered) / nrow(filtered)
    filtered <- cbind(read.table(text=names(filtered)), filtered)
    names(filtered) <- c("species", "value")
    
    #p <- ggplot(filtered, aes(x=value, y=species)) + geom_point()
    l <- c(1,2,3)
    hist(l)
    # print(p)
  #   barplot(colSums(filtered) / nrow(filtered),
  #           main=paste("Ciliate cells from", paste(source_vec, collapse=",")),
  #           #main=paste("Ciliate cells from", paste(source_vec, collapse=","), "from", input$date_min, "to", input$date_max),
            
  #           ylab="Cells",
  #           xlab="Species")
  })
  

  
}
