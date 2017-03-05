library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)


server <- function(input, output) {
  
  filtered <- reactive({
    average.score <- average.stem.data %>% 
      filter(Exam.Subject %in% input$subject) %>% 
      select(Exam.Subject, Score, Students..Male., Students..Female.) %>% 
      filter(Score == input$score | Score == "All") %>% 
      mutate(male = Students..Male.[1], male.all = Students..Male.[2]) %>% 
      mutate(female = Students..Female.[1], female.all = Students..Female.[2])
    
    percent <- average.score %>% 
      group_by(Exam.Subject) %>% 
      summarize(Male.Percent = male / male.all, Female.Percent = female / female.all) 
    
    return(percent)
  })
}
