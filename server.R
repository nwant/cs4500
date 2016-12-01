# This file creates a sidebar for use in the UI (User Interface) which is used for:
#
#     1. Choosing Arisa or ciliates to view
#     2. Choosing which test site to view
#     3. Choosing the time slice to view
#

source("./config.R")
source("./data/repo.R")
source("./data/filter.R")
library("corrplot")
library("shiny")


#=================
# server
#--------
# Controls all input and output to and from the UI
#
#
config <- get.config()
df <- get.all(config)
species <- get.species.names(df)

server <- function(input, output) {

  output$speciesSelect <- renderUI({
    # set a multiple select picklist that initializes with the first 2 species preselected
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

    # Filter the data from the input values and produce a correlation matrix based on those inputs
    f <- filter.all.data(config, df, sources, date.min, date.max, species = input$species, only.species = T)

    # server side validation for user input
    validate(
      need(length(input$species) >= 2, "You must select at least 2 species!"), # are at least 2 species selected? (corrlation matrix will only work with at least 2 species to compare)
      need(input$tt1 | input$tt2 | input$tt3, "At least one site must be selected!"), # is at least one site (T1, T2, and/or, T3) selected?
      need(date.min <= date.max, "The minimum date must be less than the maximum date selected"), # is the min date <= to the max date
      need(nrow(f) > 1, "Not enough data to compare. Please expand date time slice by increasing the End Date") # does the dataframe contain more than one row?
    )

    M <- cor(f)
    p <- corrplot(M, order="alphabet", na.label = "-")
    return(p)
  })
}
