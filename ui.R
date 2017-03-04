library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)

ui <- fluidPage(
  titlePanel("Ap Sh/t"),
  navbarPage("Menu",
             tabPanel("Summary", verbatimTextOutput("summary")),
             tabPanel("Map", plotOutput("map")),
             tabPanel("Bar Graph", plotOutput("box")),
             tabPanel("Pie Chart", plotOutput("pie")),
             tabPanel("Analysis", textOutput("analysis")),
             # create id for conditionPanel's reference
             id = "tab")
)