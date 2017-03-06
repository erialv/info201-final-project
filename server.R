library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)
library(tidyr)
library(treemap)

server <- function(input, output) {
  
  filtered <- reactive({
    average.score <- average.stem.data %>% 
      filter(Exam.Subject %in% input$subject) %>% 
      select(Exam.Subject, Score, Students..Male., Students..Female.) %>% 
      filter(Score == input$score | Score == "All") 

    percent <- average.score %>% 
      group_by(Exam.Subject) %>% 
      mutate(male.count = Students..Male.[1], male.all = Students..Male.[2]) %>% 
      mutate(female.count = Students..Female.[1], female.all = Students..Female.[2]) %>% 
      mutate(Male = male.count / male.all * 100, Female = female.count / female.all * 100) 
      
    percent <- gather(percent, key = Sex, value = Percentage, Male, Female)
    return(percent)
  })
  
  output$bar <- renderPlotly({
    graph <- ggplot(data = filtered()) +
      geom_bar(mapping = aes(x = Exam.Subject, y = Percentage, fill = Sex), stat = "identity", position = "dodge") +
      ylim(0, 100) +
      labs(x = "Exam Subjects", y = "Percentage (in %)") +
      theme(axis.text.x = element_text(hjust = 30, angle = 20), axis.title.x = element_blank())
    plotly.graph <- ggplotly(graph)
      return(plotly.graph)
    })
}
