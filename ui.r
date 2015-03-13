#ui.R
library(shiny)

# Define UI for random distribution application 
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Central Limit Theory Simulation"),
  
  # Sidebar with controls to select the random distribution type
  # and number of observations to generate. Note the use of the
  # br() element to introduce extra vertical spacing
  sidebarLayout(
    sidebarPanel(
      radioButtons("dist", "Distribution type:",
                   c("Normal" = "norm",
                     "Poisson" = "pois",
                     "Exponential" = "exp",
                     "Fair coin" = "binof",
                     "unfair coin" = "binou")),
      br(),
      
      sliderInput("popnum", 
                  "Number of population:", 
                  value = 5000,
                  min = 1000, 
                  max = 20000),
      sliderInput("sampnum", 
                  "Number of samples:", 
                  value = 1000,
                  min = 10, 
                  max = 2000),
      sliderInput("sampsize", 
                  "size of sample:", 
                  value = 50,
                  min = 10, 
                  max = 100)
    ),
    
    # Show a tabset that includes a plot, summary, and table view
    # of the generated distribution
    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("population", plotOutput("plot1")), 
                  tabPanel("sampling", plotOutput("plot2")), 
                  tabPanel("About", includeMarkdown("about.rmd"))
      )
    )
  )
))