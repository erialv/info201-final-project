library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)
library(tidyr)
library(treemap)
library(shinythemes)

data <- read.csv("data/exams.csv", stringsAsFactors = FALSE)

stem.subjects <- c("BIOLOGY", "CHEMISTRY", "CALCULUS AB", "CALCULUS BC", "COMPUTER SCIENCE A", "PHYSICS C: ELECTRICITY & MAGNETISM", "PHYSICS C: MECHANICS",
              "PHYSICS 1", "PHYSICS 2", "STATISTICS")

stem.data <- data %>% 
  filter(Exam.Subject %in% stem.subjects) %>%
  select(-Students..11th.Grade., -Students..12th.Grade.)

data.students <- read.csv("data/students.csv", stringsAsFactors = FALSE)

data.students <- data.students[-c(38, 39), ]

ui <- fluidPage(theme = shinytheme("flatly"),
  titlePanel("AP Testing: STEM Analysis"),
  navbarPage("",
             tabPanel("Summary", plotOutput("treemap"), textOutput("summary")),
             tabPanel("Scores", textOutput("scores"),
                      sidebarLayout(
                        sidebarPanel(
                          selectizeInput("subject", label = "Exam Subjects", 
                                         choices = unique(stem.data$Exam.Subject),
                                         multiple = TRUE), 
                          sliderInput("score", label = "Score", min = 1, max = 5, value = 1)),
                        mainPanel(
                          plotOutput("bar"),
                          p("The STEM subject with the highest percentages of a 5 for both males and females is AP 
                            BC. Over 50% of males scored a perfect score of 5 in this category. Another observation to 
                            note is that when you compare all of the STEM subjects in the graph, the percentage of males who 
                            scored a 5 was higher than females, across the board. This is interesting to note, because there are
                            many scholarly research articles on how women are still underrepresented in the STEM fields (See Sources
                            for more details). This leads to a bigger discussion on how to grow and increase diversity within the 
                            technology field. ")))),
             tabPanel("Demographic", textOutput("demographic"),
                      sidebarLayout(
                        sidebarPanel(
                          selectInput("subject.race", 
                                      label = "Exam Subjects", 
                                      choices = unique(stem.data$Exam.Subject))
                        ), mainPanel(plotlyOutput("pie"), p("A noteworthy observation to make is that over 
                                                              50% of the students who took all of the STEM subjects were Caucasian/White, and 
                                                              in second place were Asian. This can be explained by multiple reasons. One explanation
                                                              is because the Caucasian population is still the majority in the US. Secondly, research articles
                                                              have shown that 'Black, Hispanic, and Native American students are less likely to attend high schools 
                                                              that offer advanced courses, such as physics and calculus, and they're less likely to participate in those 
                                                              courses when they are offered.' Check out the Sources tab for more information and a link to the article.")
                                                              
                                                           ))),
             tabPanel("Sources", textOutput("sources")))
)

shinyUI(ui)