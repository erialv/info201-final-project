library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)
library(tidyr)
library(treemap)
library(RColorBrewer)

server <- function(input, output) {
  filtered <- reactive({
    scores <- stem.data %>% 
      filter(Exam.Subject %in% input$subject) %>% 
      select(Exam.Subject, Score, Students..Male., Students..Female.) %>% 
      filter(Score == input$score | Score == "All") 

    percent <- scores %>% 
      group_by(Exam.Subject) %>% 
      mutate(male.count = Students..Male.[1], male.all = Students..Male.[2]) %>% 
      mutate(female.count = Students..Female.[1], female.all = Students..Female.[2]) %>% 
      mutate(Male = male.count / male.all * 100, Female = female.count / female.all * 100) 
      
    percent <- gather(percent, key = Sex, value = Percentage, Male, Female)
    return(percent)
  })
  
  filtered.race <- reactive({
    percent.race <- stem.data %>% 
      filter(Score == "All") %>% 
      filter(Exam.Subject == input$subject.race) %>% 
      select(-Score, -Students..Male., -Students..Female.)
    
    colnames(percent.race) <- c("Exam.Subject", "White", "Black", "Hispanic/Latino", "Asian", 
                                "American-Indian/Alaska Native", "Native Hawaiian/Pacific Islander",
                                "Two or More Races", "All")
    percent.race <- gather(percent.race, key = Race, value = Population, 2:8)
    
    return(percent.race)
  })
  
  output$bar <- renderPlot({
    graph <- ggplot(data = filtered()) +
      ggtitle("Score by Gender") +
      geom_bar(mapping = aes(x = Exam.Subject, y = Percentage, fill = Sex), stat = "identity", position = "dodge") +
      ylim(0, 100) +
      labs(x = "Exam Subjects", y = "Percentage (in %)") +
      theme(axis.text.x = element_text(angle = 30, hjust = 1), axis.title.x = element_blank(), plot.title = element_text(size = 24)) +
      scale_fill_manual(values = c("#66c2a3", "#4292c5"))
      return(graph)
    })
  
  output$treemap <- renderPlot({
    t <- treemap(data.students,
                 index = c("Exam.Subject"),
                 vSize = "All.Students..2016.",
                 palette = "GnBu",
                 title = "Test Distribution",
                 fontsize.title = 24,
                 fontsize.labels = 12)
  })
  
  output$pie <- renderPlotly({
    graph <- plot_ly(filtered.race(), labels = ~Race, values = ~Population, type = "pie", 
                     textinfo = "percent", 
                     insidetextfont = list(color = "white"), hoverinfo = "text",
                     text = ~paste(Race, "\n", Population, " students")) %>%
      layout(title = "Test Taker Demographic Breakdown",
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             paper_bgcolor = "transparent",
            margin = list(b = 30, l = 30, r = 30, t = 30), legend = list(x = 10, y = -30))
    return(graph)
  })
  
  output$summary <- renderText({
    return("\n Hello")
  })
}

shinyServer(server)