library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)
library(tidyr)
library(treemap)

data <- read.csv("data/exams.csv", stringsAsFactors = FALSE)

stem.subjects <- c("BIOLOGY", "CHEMISTRY", "CALCULUS AB", "CALCULUS BC", "COMPUTER SCIENCE A", "PHYSICS C: ELECTRICITY & MAGNETISM", "PHYSICS C: MECHANICS",
              "PHYSICS 1", "PHYSICS 2", "STATISTICS")

stem.data <- data %>% 
  filter(Exam.Subject %in% stem.subjects) %>%
  select(-Students..11th.Grade., -Students..12th.Grade.)

data.students <- read.csv("data/students.csv", stringsAsFactors = FALSE)

data.students <- data.students[-c(38, 39), ]

ui <- fluidPage(
  titlePanel("Ap Sh/t"),
  navbarPage("Menu",
             tabPanel("Summary", verbatimTextOutput("summary")),
             tabPanel("Treemap", plotOutput("treemap")),
             tabPanel("Bar Graph", 
                      sidebarLayout(
                        sidebarPanel(
                          selectizeInput("subject", label = "Exam Subjects", 
                                         choices = unique(stem.data$Exam.Subject),
                                         multiple = TRUE), 
                          sliderInput("score", label = "Score", min = 1, max = 5, value = 1)),
                        mainPanel(
                          plotOutput("bar")))),
             tabPanel("Pie Chart", plotOutput("pie")),
             tabPanel("Analysis", textOutput("analysis")))
)

shinyUI(ui)