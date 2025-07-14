# server.R - Server logic for Car MPG Predictor

library(shiny)
library(plotly)
library(DT)

# Define server logic
shinyServer(function(input, output, session) {
  
  # Load and prepare data
  data <- mtcars
  data$transmission <- data$am  # am: 0 = automatic, 1 = manual
  
  # Build prediction model (reactive so it updates if needed)
  model <- reactive({
    lm(mpg ~ wt + cyl + am, data = data)
  })
  
  # Reactive values for storing results
  values <- reactiveValues(
    prediction = NULL,
    prediction_interval = NULL
  )
  
  # Make prediction when button is clicked
  observeEvent(input$predict, {
    
    # Create new data frame with user inputs
    new_data <- data.frame(
      wt = input$weight,
      cyl = as.numeric(input$cylinders),
      am = as.numeric(input$transmission)
    )
    
    # Make prediction
    pred <- predict(model(), new_data, interval = "prediction")
    
    # Store results
    values$prediction <- pred[1]
    values$prediction_interval <- pred[2:3]
  })
  
  # Output prediction text
  output$prediction_text <- renderText({
    if (is.null(values$prediction)) {
      "Click 'Predict MPG' to see results"
    } else {
      paste("Predicted MPG:", round(values$prediction, 1))
    }
  })
  
  # Output prediction details
  output$prediction_details <- renderText({
    if (is.null(values$prediction)) {
      "Enter your car's characteristics above and click the predict button."
    } else {
      paste("Prediction interval:", 
            round(values$prediction_interval[1], 1), 
            "to", 
            round(values$prediction_interval[2], 1),
            "MPG (95% confidence)")
    }
  })
  
  # Create scatter plot
  output$scatter_plot <- renderPlotly({
    
    # Base plot
    p <- plot_ly(data = data, 
                 x = ~wt, 
                 y = ~mpg,
                 color = ~factor(cyl),
                 colors = c("red", "blue", "green"),
                 type = "scatter",
                 mode = "markers",
                 marker = list(size = 10),
                 text = ~paste("Car:", rownames(data),
                               "<br>Weight:", wt,
                               "<br>MPG:", mpg,
                               "<br>Cylinders:", cyl,
                               "<br>Transmission:", ifelse(am == 1, "Manual", "Automatic")),
                 hoverinfo = "text") %>%
      layout(title = "Car Weight vs MPG by Number of Cylinders",
             xaxis = list(title = "Weight (1000 lbs)"),
             yaxis = list(title = "Miles Per Gallon"),
             showlegend = TRUE)
    
    # Add user's point if prediction has been made
    if (!is.null(values$prediction)) {
      p <- p %>%
        add_markers(x = input$weight,
                    y = values$prediction,
                    marker = list(color = "black", size = 15, symbol = "diamond"),
                    name = "Your Car",
                    text = paste("Your Prediction:",
                                 "<br>Weight:", input$weight,
                                 "<br>Predicted MPG:", round(values$prediction, 1),
                                 "<br>Cylinders:", input$cylinders,
                                 "<br>Transmission:", ifelse(input$transmission == 1, "Manual", "Automatic")),
                    hoverinfo = "text")
    }
    
    p
  })
  
  # Data table output
  output$data_table <- DT::renderDataTable({
    
    # Prepare data for display
    display_data <- data
    display_data$transmission <- ifelse(display_data$am == 1, "Manual", "Automatic")
    display_data$am <- NULL  # Remove original am column
    
    # Select relevant columns and rename
    display_data <- display_data[, c("mpg", "wt", "cyl", "transmission")]
    colnames(display_data) <- c("MPG", "Weight (1000 lbs)", "Cylinders", "Transmission")
    
    # Add car names as first column
    display_data <- cbind("Car Model" = rownames(mtcars), display_data)
    
    DT::datatable(display_data, 
                  options = list(pageLength = 10, scrollX = TRUE),
                  caption = "Motor Trend Car Road Tests Dataset (1974)")
  })
  
  # Reactive text for model summary (optional - for debugging)
  output$model_summary <- renderPrint({
    if (input$show_data) {
      summary(model())
    }
  })
})