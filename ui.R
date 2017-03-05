library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)
library(tidyr)

data <- read.csv("data/exams.csv", stringsAsFactors = FALSE)

average.stem.data <- data %>% 
  filter(Exam.Subject == "BIOLOGY" | Exam.Subject == "CHEMISTRY" | Exam.Subject == "CALCULUS AB" | 
           Exam.Subject == "CALCULUS BC" | Exam.Subject == "COMPUTER SCIENCE A" | 
           Exam.Subject == "PHYSICS C: ELECTRICTY & MAGNETISM" | Exam.Subject == "PHYSICS C: MECHANICS" |
           Exam.Subject == "PHYSICS 1" | Exam.Subject == "PHYSICS 2" | Exam.Subject == "STATISTICS") %>% 
  select(-Students..11th.Grade., -Students..12th.Grade.)


ui <- fluidPage(
  titlePanel("Ap Sh/t"),
  navbarPage("Menu",
             tabPanel("Summary", verbatimTextOutput("summary")),
             tabPanel("Map", plotOutput("map")),
             tabPanel("Bar Graph", 
                      sidebarLayout(
                        sidebarPanel(
                          selectizeInput("subject", label = "Exam Subjects", 
                                         choices = unique(average.stem.data$Exam.Subject),
                                         multiple = TRUE), 
                          sliderInput("score", label = "Score", min = 1, max = 5, value = 1)),
                        mainPanel(
                          plotlyOutput("bar", height = "500px")))),
             tabPanel("Pie Chart", plotOutput("pie")),
             tabPanel("Analysis", textOutput("analysis")))
)