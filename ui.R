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
), multiple = TRUE),
selectizeInput(
'3', '3. Site', choices=list(
'T1'='t1','T2'='t2','T3'='t3'

#`New York` = 'NY', `New Jersey` = 'NJ',
#`California` = 'CA', `Washington` = 'WA'
), multiple = TRUE),
sliderInput("integer", "Integer:",
min=0, max=1000, value=500),
numericInput("num", "Number:",NULL)
),
mainPanel()
)
