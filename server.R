library(shiny)

arisa <- read.csv("./data/ARISA.CSV", header = TRUE)
arisa$source <- substr(arisa$X, 1, 3)

server <- function(input, output) {
  output$hist <- renderPlot({ 
    title <- "100 random normal values"
    hist(rnorm(100), main = title)
  })

  output$arisa_plot <- renderPlot({
    filtered <- arisa[arisa$source %in% c(if(input$tt1) "TT1" else NULL, if(input$tt2) "TT2" else NULL, if(input$tt3) "TT3" else NULL),]
    filtered$X <- NULL
    filtered$source <- NULL
    
    # Render a barplot
    barplot(colSums(filtered),
            main=input$region,
            ylab="Number of Telephones",
            xlab="Year")
  })
}
