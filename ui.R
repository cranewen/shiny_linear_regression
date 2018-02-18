library(shiny)

shinyUI(fluidPage(

  
  titlePanel("Simple Linear Regression"),

  
  sidebarLayout(
    sidebarPanel(
      fileInput(inputId = "file", label = "Choose CSV File", 
                 multiple = FALSE,
                 accept = c("text/csv",
                            "text/comma-separated-values,text/plain",
                            ".csv")),
      selectizeInput(inputId = "dv", label = "Please select the dependent variable",
                     choices = NULL, options = list(create = FALSE)),
      textInput(inputId = "train_test_ratio", label = "ratio", value = ''),
      textInput(inputId = "plot_train_title", label = "Type training set plot title", value = ''),
      textInput(inputId = "plot_test_title", label = "Type test set plot title", value = ''),
      textInput(inputId = "x_axis", label = "Type x axis lable", value = ''),
      textInput(inputId = "y_axis", label = "Type y axis lable", value = ''),
      
      actionButton(inputId = "plot_simple_lm", label = "plotting")
    ),

    
    mainPanel(
      plotOutput("trainingPlot"),
      plotOutput("testPlot")
    )
  )
))
