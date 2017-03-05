library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)


server <- function(input, output) {
  
  filtered <- reactive({
    average.score <- average.stem.data %>% 
      filter(Exam.Subject %in% input$subject) %>% 
      select(Exam.Subject, Score, Students..Male., Students..Female.) %>% 
      filter(Score == input$score | Score == "All")
    
    percent <- average.score %>% 
      group_by(Exam.Subject) %>% 
      summarize(Male.Percent = )
    
    return()
  })
}
