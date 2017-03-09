library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)
library(tidyr)
library(treemap)
library(RColorBrewer)
source("source.R")

server <- function(input, output) {
  
  # Filters data by inputted subject and score and only extracts necessary columns
  filtered <- reactive({
    scores <- stem.data %>% 
      filter(Exam.Subject %in% input$subject) %>% 
      select(Exam.Subject, Score, Students..Male., Students..Female.) %>% 
      filter(Score == input$score | Score == "All") 
  
    # Produce percentages of males/females that took a particular subject and received a 
    # particular score to be used in bar graph
    percent <- scores %>% 
      group_by(Exam.Subject) %>% 
      mutate(male.count = Students..Male.[1], male.all = Students..Male.[2]) %>% 
      mutate(female.count = Students..Female.[1], female.all = Students..Female.[2]) %>% 
      mutate(Male = male.count / male.all * 100, Female = female.count / female.all * 100) 
      
    percent <- gather(percent, key = Sex, value = Percentage, Male, Female)
    return(percent)
  })
  
  # Filters data for pie chart by race and selected STEM subject(s) while excluding unnecessary data
  filtered.race <- reactive({
    percent.race <- stem.data %>% 
      filter(Score == "All") %>% 
      filter(Exam.Subject == input$subject.race) %>% 
      select(-Score, -Students..Male., -Students..Female.)
    
    # Set column names to more human-friendly readable names
    colnames(percent.race) <- c("Exam.Subject", "White", "Black", "Hispanic/Latino", "Asian", 
                                "American-Indian/Alaska Native", "Native Hawaiian/Pacific Islander",
                                "Two or More Races", "All")
    
    # Gather race identifier data into a single column
    percent.race <- gather(percent.race, key = Race, value = Population, 2:8)
    
    return(percent.race)
  })
  
  # Creates bar graph with rotated axis labels, a constant y height of 100% for scale, and custom colors
  output$bar <- renderPlot({
    graph <- ggplot(data = filtered()) +
      ggtitle("Score by Gender") +
      geom_bar(mapping = aes(x = Exam.Subject, y = Percentage, fill = Sex), stat = "identity", position = "dodge") +
      
      # Set y limit to 100 (representing 100 percent)
      ylim(0, 100) +
      
      # Custom axis labels
      labs(x = "Exam Subjects", y = "Percentage (in %)") +
      theme(axis.text.x = element_text(angle = 30, hjust = 1), axis.title.x = element_blank(), plot.title = element_text(size = 24)) +
      
      # Custom colors for bars
      scale_fill_manual(values = c("#66c2a3", "#4292c5"))
      return(graph)
    })
  
  # Treemap indicating number of tests taken for all subjects with custom colors
  output$treemap <- renderPlot({
    t <- treemap(data.students,
                 index = c("Exam.Subject"),
                 vSize = "All.Students..2016.",
                 palette = "GnBu",
                 title = "Test Distribution",
                 fontsize.title = 24,
                 fontsize.labels = 12)
  })
  
  # Pie chart for number of tests taken by race for a selected STEM subject
  output$pie <- renderPlotly({
    graph <- plot_ly(filtered.race(), labels = ~Race, values = ~Population, type = "pie", 
                     textinfo = "percent", 
                     
                     # Customize text, text color, and hover information
                     insidetextfont = list(color = "white"), hoverinfo = "text",
                     text = ~paste(Race, "\n", Population, " students")) %>%
      layout(title = "Test Taker Demographic Breakdown",
             
             # Set grid, lines, and labels to false so they do not show in the pie chart
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             paper_bgcolor = "transparent",
             
             # Set margins so text is not cut off
            margin = list(b = 30, l = 30, r = 30, t = 30), legend = list(x = 10, y = -30))
    return(graph)
  })
  
  # Text for summary tab that accompanies treemap
  output$summary <- renderText({
    return("Advanced Placement (AP) exams, administered by the College Board, are taken yearly by high school students across the United States. More than 90% of four-year colleges in the United States offer credits, advanced placement, or both based on AP exam scores. Earning AP 
credits can help students graduate in four years and have more time to pursue activities, such as studying abroad, completing internships, etc.
This project is focused on analyzing the 2016 STEM (Science, Technology, Engineering, Math) AP exams. 
High school students who are interested in majoring in Informatics and Computer Science will be able to 
see how they perform compared to one another based on their different demographics, gender, and STEM subject 
testing. Education administrators (STEM teachers, principals, college admissions staff) can use the data to see the overall 
performance of test takers by STEM subject and gain insight on how different groups perform. That way, the administrators can 
may do some adjustments to the tests or to generalize the performance curve of different groups. Additionally, college admissions
staff can use this data to aid in their college admissions decisions."
    )
  })
  
  # Analysis text for bar graph 
  output$scores <- renderText({
  return("The following bar graph shows scores of the different STEM subjects, by gender. You can select more than one 
subject to compare and contrast the scores by gender. Use the slider to indicate which particular score (on a scale of 1 to 5) 
you would like to view."
  )
    
})
  
  output$scorestext <- renderText({
    return("The STEM subject with the highest percentages of a 5 for both males and females is AP Calculus 
BC. Over 50% of males scored a perfect score of 5 in this category. Another observation to 
note is that when you compare all of the STEM subjects in the graph, the percentage of males who 
scored a 5 was higher than females, across the board. This is interesting to note, because there are
many scholarly research articles on how women are still underrepresented in the STEM fields (See 
Sources for more details). This leads to a bigger discussion on how to grow and increase 
diversity within the technology field.")
  })
  
  # Analysis text for pie chart
  output$demographic <- renderText({
    return("The following pie chart shows what percentage of each race/demographic group took a particular STEM subject exam. Click the 
dropdown to specify which subject you would like to see the breakdown of."
    )
    
  })
  
  output$demographictext <- renderText({
    return("A noteworthy observation to make is that over 50% of the students who took all of the STEM subjects 
were Caucasian/White, and in second place were Asian. This can be explained by multiple reasons. One explanation is because the Caucasian population is still the majority in the US. Secondly, research 
articles have shown that 'Black, Hispanic, and Native American students are less likely to attend 
high schools that offer advanced courses, such as physics and calculus, and they're less likely to 
participate in those courses when they are offered. 
Check out the Sources tab for more information and a link to the article.")
  })
  
  # Text for source data
  output$sources <- renderText({
    return("Here is the link to where we found our dataset. 
The scores were derived and taken from the College Board: 
https://www.kaggle.com/collegeboard/ap-scores

This is the link to an article on how women are still underrepresented in STEM fields: 
https://www.usnews.com/news/articles/2015/10/21/women-still-underrepresented-in-stem-fields

This is the link to an article on the 'race gap' in high school AP classes: 
https://www.theatlantic.com/politics/archive/2014/12/the-race-gap-in-high-school-honors-classes/431751/"
           )
  })
}



shinyServer(server)