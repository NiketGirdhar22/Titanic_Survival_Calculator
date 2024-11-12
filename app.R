library(shiny)
library(dplyr)
library(ggplot2)

titanic_data <- read.csv("titanic_dataset.csv")
titanic_data <- na.omit(titanic_data)
titanic_data$Pclass <- factor(titanic_data$Pclass, levels = c(1, 2, 3))
titanic_data$Sex <- factor(titanic_data$Sex, levels = c("male", "female"))
titanic_data$Embarked <- factor(titanic_data$Embarked, levels = c("C", "Q", "S"))
titanic_data$Survived <- factor(titanic_data$Survived, levels = c(0, 1), labels = c("No", "Yes"))

model <- glm(Survived ~ Pclass + Sex + Age + Embarked, data = titanic_data, family = binomial)

ui <- fluidPage(
  titlePanel("Titanic Survival Prediction"),
  sidebarLayout(
    sidebarPanel(
      selectInput("pclass", "Ticket Class", choices = c("1st" = 1, "2nd" = 2, "3rd" = 3)),
      selectInput("sex", "Sex", choices = c("Male" = "male", "Female" = "female")),
      numericInput("age", "Age", value = 30, min = 0, max = 100),
      selectInput("embarked", "Port of Embarkation", choices = c("Cherbourg" = "C", "Queenstown" = "Q", "Southampton" = "S")),
      actionButton("predict", "Check Survival")
    ),
    mainPanel(
      textOutput("result"),
      verbatimTextOutput("debug_info"),
      fluidRow(
        column(width = 6, plotOutput("gender_class_plot")),
        column(width = 6, plotOutput("age_class_plot"))
      ),
      plotOutput("ticket_class_plot"),
      plotOutput("model_coefficients_plot")  # Added this plot for model coefficients
    )
  )
)

server <- function(input, output) {
  
  observeEvent(input$predict, {
    user_data <- data.frame(
      Pclass = factor(as.integer(input$pclass), levels = levels(titanic_data$Pclass)),
      Sex = factor(input$sex, levels = levels(titanic_data$Sex)),
      Age = as.numeric(input$age),
      Embarked = factor(input$embarked, levels = levels(titanic_data$Embarked))
    )
    prediction <- predict(model, newdata = user_data, type = "response")
    survival <- ifelse(prediction > 0.5, "Yes", "No")
    survival_num <- ifelse(survival == "Yes", 1, 0)
    
    output$result <- renderText({
      paste("Predicted Survival:", survival, "(Probability:", round(prediction * 100, 2), "%)")
    })
    
    output$ticket_class_plot <- renderPlot({
      user_point <- data.frame(
        Pclass = factor(as.integer(input$pclass), levels = levels(titanic_data$Pclass)),
        Survived = factor(survival, levels = c("No", "Yes"))
      )
      ggplot(titanic_data, aes(x = Pclass, fill = Survived)) +
        geom_bar(position = "fill") +
        labs(title = "Survival Rate by Ticket Class", x = "Ticket Class", y = "Proportion") +
        scale_fill_manual(values = c("No" = "red", "Yes" = "green")) +
        theme_minimal() +
        geom_point(data = user_point, aes(x = Pclass, y = survival_num), color = "black", size = 3, shape = 4)
    })
  })
  
  output$gender_class_plot <- renderPlot({
    ggplot(titanic_data, aes(x = Sex, fill = Survived)) +
      geom_bar(position = "fill") +
      facet_wrap(~ Pclass) +
      labs(title = "Survival Rate by Gender and Class", x = "Gender", y = "Proportion") +
      scale_fill_manual(values = c("No" = "red", "Yes" = "green")) +
      theme_minimal()
  })
  
  output$age_class_plot <- renderPlot({
    ggplot(titanic_data, aes(x = Pclass, y = Age, fill = Survived)) +
      geom_boxplot(alpha = 0.6) +
      labs(title = "Age Distribution by Ticket Class and Survival", x = "Ticket Class", y = "Age") +
      scale_fill_manual(values = c("No" = "red", "Yes" = "green")) +
      theme_minimal()
  })
  
  output$model_coefficients_plot <- renderPlot({
    coeffs <- coef(model)
    coeff_df <- data.frame(
      Predictor = names(coeffs),
      Coefficient = coeffs
    )
    
    ggplot(coeff_df, aes(x = reorder(Predictor, Coefficient), y = Coefficient, fill = Coefficient)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      labs(title = "Model Coefficients", x = "Predictor", y = "Coefficient Value") +
      scale_fill_gradient2(low = "blue", high = "red", mid = "white", midpoint = 0) +
      theme_minimal()
  })
  
  output$debug_info <- renderPrint({
    user_data <- data.frame(
      Pclass = factor(as.integer(input$pclass), levels = levels(titanic_data$Pclass)),
      Sex = factor(input$sex, levels = levels(titanic_data$Sex)),
      Age = as.numeric(input$age),
      Embarked = factor(input$embarked, levels = levels(titanic_data$Embarked))
    )
    print(user_data)
  })
}

shinyApp(ui = ui, server = server)
