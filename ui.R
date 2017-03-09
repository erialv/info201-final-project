library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)
library(tidyr)
library(treemap)
library(shinythemes)

# read in relevant data
data <- read.csv("data/exams.csv", stringsAsFactors = FALSE)

# vector of STEM subjects to filter with
stem.subjects <- c("BIOLOGY", "CHEMISTRY", "CALCULUS AB", "CALCULUS BC", "COMPUTER SCIENCE A", "PHYSICS C: ELECTRICITY & MAGNETISM", "PHYSICS C: MECHANICS",
              "PHYSICS 1", "PHYSICS 2", "STATISTICS")

# Filter for STEM subjects and exclude columns on 11th and 12th grade student data
stem.data <- data %>% 
  filter(Exam.Subject %in% stem.subjects) %>%
  select(-Students..11th.Grade., -Students..12th.Grade.)

# Read in more relevant data
data.students <- read.csv("data/students.csv", stringsAsFactors = FALSE)

# Exclude rows on "all subjects" data
data.students <- data.students[-c(38, 39), ]

# Set Shiny app theme to Flatly
ui <- fluidPage(theme = shinytheme("flatly"),
  titlePanel("AP Testing: STEM Analysis"),
  # Set layout to navbar page
  navbarPage("",
             # Create 4 tabs named summary, scores, demographics, and sources
             # Summary panel with a treemap for all subjects and summary text
             tabPanel("Summary", plotOutput("treemap"), verbatimTextOutput("summary")),
             # Bar graph comparing scores by gender for STEM subjects with analysis
             tabPanel("Scores", verbatimTextOutput("scores"),
                      sidebarLayout(
                        sidebarPanel(
                          # Multi-select allows to select between 1 and all STEM subjects
                          selectizeInput("subject", label = "Exam Subjects", 
                                         choices = unique(stem.data$Exam.Subject),
                                         multiple = TRUE), 
                          # Slider to select score (not ranged) to show data for
                          sliderInput("score", label = "Score", min = 1, max = 5, value = 1)),
                        mainPanel(
                          plotOutput("bar"), verbatimTextOutput("scorestext")))),
                          # Analysis for bar graph
             # Demographic makeup of test takers for a STEM subject in a pie chart
             tabPanel("Demographic", verbatimTextOutput("demographic"),
                      sidebarLayout(
                        sidebarPanel(
                          # Select a STEM subject to see demographic data for (one subject selectable at a time)
                          selectInput("subject.race", 
                                      label = "Exam Subjects", 
                                      choices = unique(stem.data$Exam.Subject))
                          # Analysis of demographic data pie chart
                        ), mainPanel(plotlyOutput("pie"), verbatimTextOutput("demographictext")))),
             # Citations for data
             tabPanel("Sources", verbatimTextOutput("sources")))
)

shinyUI(ui)