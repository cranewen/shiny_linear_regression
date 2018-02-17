library(shiny)

shinyUI(fluidPage(

  
  titlePanel("Linear Regression"),

  
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
      actionButton(inputId = "plot_simple_lm", label = "plotting")
    ),

    
    mainPanel(
      plotOutput("trainingPlot"),
      plotOutput("testPlot")
    )
  )
))
