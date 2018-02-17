library(shiny)
library(caTools)
library(ggplot2)


shinyServer(function(input, output, session) {
  
  getData <- function() {
    reactive({
      req(input$file)
      df <- read.csv(file = input$file, header = TRUE)
    })
    return(df)
  }
  
  selectDependentVar <- names(getData())
  
  updateSelectizeInput(session, inputId = "dv", choices = selectDependentVar, server = TRUE)
  
  df <- getData()
  
  getSplitter <- function() {
    splitter <- reactive( {
      sample.split(df$Salary, SplitRatio = as.numeric(input$train_test_ratio))
    })
    return(splitter())
  }
  
 
  
  observeEvent(input$plot_simple_lm, {
    splitter <- getSplitter()
    training_set <- subset(df, splitter == TRUE)
    test_set <- subset(df, splitter == FALSE)
    
    print(training_set)
    print(test_set)
    
    regr <- lm(Salary ~ YearsExperience, training_set)
    y_pred <- predict(regr, newdata = test_set)
    output$trainingPlot <- renderPlot(ggplot() + geom_point(aes(x = training_set$YearsExperience, y = training_set$Salary), color = 'red') + 
                                        geom_line(aes(x = training_set$YearsExperience, y = predict(regr, newdata = training_set)), color = 'blue') + 
                                        ggtitle('Salary vs Experience (Training set)') + 
                                        xlab('Years of Experience') + ylab('Salary'))
    
    output$testPlot <- renderPlot(
      ggplot() + 
        geom_point(aes(x = test_set$YearsExperience, y = test_set$Salary), color = 'red') + 
        geom_line(aes(x = training_set$YearsExperience, y = predict(regr, newdata = training_set)), color = 'blue') + 
        ggtitle('Salary vs Experience (Test set)') + 
        xlab('Years of Experience') + ylab('Salary')
    )
  })

})
