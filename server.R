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
      sample.split(df[[input$dv]], SplitRatio = as.numeric(input$train_test_ratio))
    })
    return(splitter())
  }
  
  observeEvent(input$plot_simple_lm, {
    splitter <- getSplitter()
    training_set <- subset(df, splitter == TRUE)
    test_set <- subset(df, splitter == FALSE)

    # print(training_set)
    # print(test_set)

    dependentVar <- input$dv
    independentVar <- selectDependentVar[is.na(pmatch(selectDependentVar,input$dv))]
    lm_function <- paste(dependentVar, independentVar, sep = " ~ ")
    

    regr <- lm(lm_function, training_set)
    y_pred <- predict(regr, newdata = test_set)
    output$trainingPlot <- renderPlot(ggplot() + geom_point(aes(x = training_set[[independentVar]], y = training_set[[dependentVar]]), color = 'red') +
                                        geom_line(aes(x = training_set[[independentVar]], y = predict(regr, newdata = training_set)), color = 'blue') +
                                        ggtitle(input$plot_train_title) +
                                        xlab(input$x_axis) + ylab(input$y_axis))

    output$testPlot <- renderPlot(
      ggplot() +
        geom_point(aes(x = test_set[[independentVar]], y = test_set[[dependentVar]]), color = 'red') +
        geom_line(aes(x = training_set[[independentVar]], y = predict(regr, newdata = training_set)), color = 'blue') +
        ggtitle(input$plot_test_title) +
        xlab(input$x_axis) + ylab(input$y_axis)
    )
  })

})
