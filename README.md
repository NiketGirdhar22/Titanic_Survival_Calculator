
# Titanic Survival Prediction Shiny App

This Shiny app allows users to predict the survival probability of a Titanic passenger based on selected features, such as ticket class, gender, age, and embarkation port. The app utilizes a logistic regression model trained on the Titanic dataset to predict the likelihood of survival.

## Features

- **Survival Prediction**: Input a passenger's ticket class, gender, age, and embarkation port to predict their survival status (Yes/No).
- **Visualizations**: View various plots that provide insights into survival rates:
  - Survival rate by ticket class.
  - Survival rate by gender and class.
  - Age distribution by ticket class and survival status.
  - Model coefficients that were used to train the logistic regression model.

## App Overview

The app consists of two main sections:

### 1. **User Inputs**:
   - **Ticket Class**: Select between 1st, 2nd, or 3rd class.
   - **Gender**: Choose between Male or Female.
   - **Age**: Input an age value (between 0 and 100).
   - **Embarkation Port**: Select between Cherbourg (C), Queenstown (Q), and Southampton (S).
   - **Predict Button**: Click the button to see the predicted survival status and associated probability.

### 2. **Main Panel**:
   - **Predicted Survival**: Displays the predicted survival status and probability.
   - **Debug Info**: A table showing the user's input data (optional).
   - **Plots**:
     - **Survival Rate by Ticket Class**: A bar chart showing survival rates based on ticket class.
     - **Survival Rate by Gender and Class**: A bar chart showing survival rates based on gender and class.
     - **Age Distribution by Ticket Class and Survival**: A box plot displaying age distribution by ticket class and survival status.
     - **Model Coefficients**: A bar plot showing the coefficients of the logistic regression model.

## Installation

To run the app locally, follow the steps below:

### Prerequisites:
Ensure you have the following installed:
- **R**: [Download R](https://cran.r-project.org/)
- **RStudio** (Optional but recommended): [Download RStudio](https://rstudio.com/products/rstudio/download/)

### Installing Dependencies:
In R, install the necessary packages using the following commands:

```R
install.packages("shiny")
install.packages("dplyr")
install.packages("ggplot2")
```

### Running the App:
Clone or download this repository to your local machine. Set your working directory in R to the folder containing the app files. Run the following R code to start the app:

```R
library(shiny)
runApp("path_to_your_app_folder")
```

Alternatively, open the app file in RStudio and click Run App.

## Data

The app is based on the Titanic dataset, which contains data on passengers aboard the Titanic. The dataset is used to build a logistic regression model for predicting survival. The key features used for prediction include:

- Pclass (Ticket Class): 1st, 2nd, or 3rd class.
- Sex: Male or Female.
- Age: Age of the passenger.
- Embarked: Embarkation port (Cherbourg, Queenstown, Southampton).
- Survived: Whether the passenger survived or not (1 = Yes, 0 = No).

You can download the Titanic dataset from Kaggle's Titanic Dataset.

### Data Preprocessing:
- Missing values in the Age column are removed (using `na.omit`).
- The Survived, Pclass, Sex, and Embarked columns are converted into factors for model training.

## Model Details

The app uses a logistic regression model (`glm`) to predict the survival of passengers. The model formula is:

```R
model <- glm(Survived ~ Pclass + Sex + Age + Embarked, data = titanic_data, family = binomial)
```

### Interpretation of Results:
- **Prediction**: The app displays whether the passenger is predicted to survive or not based on the logistic regression model.
- **Model Coefficients Plot**: This plot shows the coefficients of the logistic regression model. Positive coefficients increase the probability of survival, while negative coefficients decrease it.

## Troubleshooting

- **Missing Data**: If the dataset contains missing values, they will be removed automatically using `na.omit`. However, you can adjust this behavior by modifying the preprocessing code.
- **App Not Loading**: Ensure all necessary R packages are installed. You can install missing packages using `install.packages()`.
- **Incorrect Input**: If the user inputs invalid data (e.g., a negative age), an error message will be shown.

## Acknowledgements

The Titanic dataset is available on Kaggle and is a popular dataset used for machine learning and data science tasks. The app uses the Shiny framework for R to create interactive web applications.
