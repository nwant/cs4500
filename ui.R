library(shiny)


ui <- pageWithSidebar(
  
  # Application title
  headerPanel("SidePanel"),
  
  # Sidebar with controls to select the variable to plot against mpg
  # and to specify whether outliers should be included
  sidebarPanel(
  
    selectInput("1", "1. Select",
      choices=list(
      'Colpodida'='Col','Cyrtophorida'='Cyr','Gymnostomatida'='Gym','Heterotrichida'='Het',
      'Hymenostomatida'='Hym','Hypotrichida'='Hyp','Oligotrichida'='Oli','Peritrichida'='Per',
      'Pleurostomatida'='Ple','Prostomatida'='Pro','Suctorida'='Suc'
      )),
      selectizeInput(
      '2', '2. Multi-select', choices=list(
      'Colpodida'='Col','Cyrtophorida'='Cyr','Gymnostomatida'='Gym','Heterotrichida'='Het',
      'Hymenostomatida'='Hym','Hypotrichida'='Hyp','Oligotrichida'='Oli','Peritrichida'='Per',
      'Pleurostomatida'='Ple','Prostomatida'='Pro','Suctorida'='Suc'
      
      #`New York` = 'NY', `New Jersey` = 'NJ',
      #`California` = 'CA', `Washington` = 'WA'
      ), multiple = TRUE
    ),
  
    selectizeInput(
      '3', '3. Site', choices=list(
      'T1'='t1','T2'='t2','T3'='t3'
      
      #`New York` = 'NY', `New Jersey` = 'NJ',
      #`California` = 'CA', `Washington` = 'WA'
      ), multiple = TRUE),
      sliderInput("integer", "Integer:",
      min=0, max=1000, value=500
    ),
  
    numericInput("num", "Number:",NULL),
  
    checkboxInput(inputId = "tt1",
      label = strong("Show TT1"),
      value = TRUE),
      
    checkboxInput(inputId = "tt2",
      label = strong("Show TT2"),
      value = TRUE),
      
    checkboxInput(inputId = "tt3",
      label = strong("Show TT3"),
      value = TRUE),
      
    dateInput(inputId = "date_min", "Date Start", value = "2008-01-11", min = "2008-01-11", max = "2013-08-01",
      format = "yyyy-mm-dd", startview = "month", weekstart = 0,
      language = "en", width = NULL),
      
    dateInput(inputId = "date_max", "Date End", value = "2013-08-01", min = "2008-01-11", max = "2013-08-01",
      format = "yyyy-mm-dd", startview = "month", weekstart = 0,
      language = "en", width = NULL)

  ),
  mainPanel(
    plotOutput("arisa_plot")
  )
)
