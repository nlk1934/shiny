#server.R
library(shiny)
library(ggplot2)

# Define server logic for random distribution application
shinyServer(function(input, output) {
  
  # Reactive expression to generate the requested distribution.
  # This is called whenever the inputs change. The output
  # functions defined below then all use the value computed from
  # this expression
  population <- reactive({
    populationSize <- input$popnum
    population <- switch(input$dist,
                   norm = rnorm(populationSize), 
                   pois = rpois(populationSize, 100),
                   exp = rexp(populationSize, 1/10),
                   binof = rbinom(populationSize, 1, prob=0.5),
                   binou = rbinom(populationSize, 1, prob=0.75)
                   )
  })
  
  # Generate a plot of the data. Also uses the inputs to build
  # the plot label. Note that the dependencies on both the inputs
  # and the data reactive expression are both tracked, and
  # all expressions are called in the sequence implied by the
  # dependency graph
  output$plot1 <- renderPlot({
    populationSize <- input$popnum
    qplot(population(), geom = 'blank') + 
      geom_histogram(aes(y = ..density..), 
                     binwidth=(max(population())-min(population()))/20, 
                     color='white', fill='lightsteelblue')  +
      geom_vline(xintercept = mean(population()), colour = 'red', size=.5) +
      theme(axis.title.x=element_blank(), axis.title.y=element_blank())
  })
  
  output$plot2 <- renderPlot({
    sampleNum <- input$sampnum; 
    sampleSize <- input$sampsize;
    samples <- matrix(data=NA, nrow=sampleNum, ncol=sampleSize)
    for(i in 1:sampleNum){
      samples[i,] <- sample(x=population(), size=sampleSize, replace = FALSE)
    }
    x_bars <- apply(samples, 1, mean)
    plot_clt <- qplot(x_bars, geom = 'blank') +  
      geom_histogram(aes(y = ..density..),  
                     binwidth = (max(x_bars)-min(x_bars))/20,
                     colour="white", fill='lightsteelblue') +
      geom_line(aes(colour = 'Empirical'), stat = 'density', size=.5) +  
      stat_function(fun=dnorm, 
                    args=list(mean=mean(population()), sd=sd(population())/sqrt(sampleSize)),
                    aes(colour = 'Theoretical'), size=.5) +
      geom_vline(xintercept = mean(x_bars), colour = 'red',size=.5) + 
      scale_colour_manual(name='', values = c('red', 'blue')) + 
      theme(legend.position = c(0.85, 0.85)) + xlab("means of samples")
    print(plot_clt)
  })
  
  # Generate a summary of the data
  output$summary <- renderPrint({
    summary(data())
  })
  
  # Generate an HTML table view of the data
  output$table <- renderTable({
    data.frame(x=data())
  })
  
})
