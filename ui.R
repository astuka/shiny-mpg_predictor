
# ui.R - User Interface for Car MPG Predictor

library(shiny)
library(shinythemes)
library(plotly)
library(DT)

# Define UI
shinyUI(fluidPage(
  
  # Use a theme for better appearance
  theme = shinytheme("flatly"),
  
  # Application title
  titlePanel("Car Fuel Efficiency Predictor"),
  
  # Create tabbed interface
  tabsetPanel(
    
    # Main application tab
    tabPanel("Predictor",
             sidebarLayout(
               sidebarPanel(
                 width = 4,
                 
                 # Instructions
                 h4("Select Car Characteristics:"),
                 p("Use the controls below to predict a car's fuel efficiency (MPG)."),
                 
                 # Input widgets
                 sliderInput("weight",
                             "Car Weight (1000 lbs):",
                             min = 1.5,
                             max = 5.5,
                             value = 3.2,
                             step = 0.1),
                 
                 selectInput("cylinders",
                             "Number of Cylinders:",
                             choices = c(4, 6, 8),
                             selected = 6),
                 
                 radioButtons("transmission",
                              "Transmission Type:",
                              choices = list("Automatic" = 0, "Manual" = 1),
                              selected = 0),
                 
                 checkboxInput("show_data",
                               "Show raw data table",
                               value = FALSE),
                 
                 br(),
                 
                 # Action button
                 actionButton("predict", "Predict MPG", 
                              class = "btn-primary"),
                 
                 br(), br(),
                 
                 # Help text
                 helpText("Note: Predictions are based on the mtcars dataset and may not reflect modern vehicle efficiency.")
               ),
               
               mainPanel(
                 width = 8,
                 
                 # Output areas
                 h4("Prediction Results"),
                 
                 # Prediction output
                 wellPanel(
                   h3(textOutput("prediction_text")),
                   textOutput("prediction_details")
                 ),
                 
                 # Plot output
                 h4("Data Visualization"),
                 plotlyOutput("scatter_plot"),
                 
                 # Conditional data table
                 conditionalPanel(
                   condition = "input.show_data == true",
                   h4("Raw Data (mtcars dataset)"),
                   DT::dataTableOutput("data_table")
                 )
               )
             )
    ),
    
    # Documentation tab
    tabPanel("How to Use",
             fluidRow(
               column(12,
                      h3("How to Use the Car MPG Predictor"),
                      
                      h4("Overview"),
                      p("This application predicts a car's fuel efficiency (Miles Per Gallon) based on three key characteristics:"),
                      tags$ul(
                        tags$li("Weight of the car"),
                        tags$li("Number of cylinders in the engine"),
                        tags$li("Transmission type (automatic or manual)")
                      ),
                      
                      h4("Step-by-Step Instructions"),
                      tags$ol(
                        tags$li(strong("Adjust the Weight Slider:"), " Move the slider to select the car's weight in thousands of pounds. Heavier cars typically have lower MPG."),
                        tags$li(strong("Select Number of Cylinders:"), " Choose 4, 6, or 8 cylinders. More cylinders usually mean more power but lower fuel efficiency."),
                        tags$li(strong("Choose Transmission Type:"), " Select either Automatic or Manual transmission."),
                        tags$li(strong("Click 'Predict MPG':"), " Press the blue button to calculate the predicted fuel efficiency."),
                        tags$li(strong("View Results:"), " The predicted MPG will appear in the results box, along with additional details."),
                        tags$li(strong("Explore the Data:"), " Check the 'Show raw data table' box to see the underlying dataset used for predictions.")
                      ),
                      
                      h4("Understanding the Results"),
                      p("The prediction is based on a statistical model trained on the famous 'mtcars' dataset, which contains information about 32 different car models from 1973-1974. The scatter plot shows how your selected car compares to the historical data."),
                      
                      h4("Tips for Best Results"),
                      tags$ul(
                        tags$li("Try different combinations to see how each factor affects fuel efficiency"),
                        tags$li("Use the visualization to understand the relationship between weight and MPG"),
                        tags$li("Remember that these predictions are based on older car models and may not reflect modern vehicle technology")
                      )
               )
             )
    ),
    
    # About tab
    tabPanel("About",
             fluidRow(
               column(12,
                      h3("About This Application"),
                      
                      h4("Purpose"),
                      p("This Shiny application demonstrates predictive modeling using R's built-in mtcars dataset. It provides an interactive way to explore how different car characteristics affect fuel efficiency."),
                      
                      h4("Technical Details"),
                      p("The prediction model uses multiple linear regression with the following formula:"),
                      code("MPG ~ Weight + Cylinders + Transmission"),
                      
                      h4("Data Source"),
                      p("The application uses the 'mtcars' dataset, which is included with R. This dataset contains fuel consumption and 10 aspects of automobile design and performance for 32 automobiles (1973-74 models)."),
                      
                      h4("Variables Used"),
                      tags$ul(
                        tags$li(strong("MPG:"), " Miles per gallon (dependent variable)"),
                        tags$li(strong("Weight:"), " Car weight in thousands of pounds"),
                        tags$li(strong("Cylinders:"), " Number of engine cylinders"),
                        tags$li(strong("Transmission:"), " Type of transmission (0 = automatic, 1 = manual)")
                      ),
                      
                      h4("Limitations"),
                      tags$ul(
                        tags$li("Based on 1970s car models - may not reflect modern efficiency"),
                        tags$li("Limited to the specific variables in the original dataset"),
                        tags$li("Predictions are estimates and should not be used for actual car purchasing decisions")
                      ),
                      
                      h4("Technology"),
                      p("Built with R and Shiny framework, using the following packages:"),
                      tags$ul(
                        tags$li("shiny - Web application framework"),
                        tags$li("shinythemes - Bootstrap themes"),
                        tags$li("plotly - Interactive plots"),
                        tags$li("DT - Interactive data tables")
                      ),
                      
                      br(),
                      p("Created as a demonstration of interactive data science applications.")
               )
             )
    )
  )
))