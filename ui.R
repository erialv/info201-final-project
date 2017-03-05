library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)

data <- read.csv("data/exams.csv", stringsAsFactors = FALSE)

average.stem.data <- data %>% 
  filter(Exam.Subject == "BIOLOGY" | Exam.Subject == "CHEMISTRY" | Exam.Subject == "CALCULUS AB" | 
           Exam.Subject == "CALCULUS BC" | Exam.Subject == "COMPUTER SCIENCE A" | 
           Exam.Subject == "PHYSICS C: ELECTRICTY & MAGNETISM" | Exam.Subject == "PHYSICS C: MECHANICS" |
           Exam.Subject == "PHYSICS 1" | Exam.Subject == "PHYSICS 2" | Exam.Subject == "STATISTICS") %>% 
  filter(Score == "Average" | Score == "All") %>% 
  select(-Students..11th.Grade., -Students..12th.Grade.)

ui <- fluidPage(
  titlePanel("Ap Sh/t"),
  navbarPage("Menu",
             tabPanel("Summary", verbatimTextOutput("summary")),
             tabPanel("Map", plotOutput("map")),
             tabPanel("Bar Graph", plotOutput("box")),
             tabPanel("Pie Chart", plotOutput("pie")),
             tabPanel("Analysis", textOutput("analysis")))
)