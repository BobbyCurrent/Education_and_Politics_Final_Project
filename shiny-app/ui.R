#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(tidyverse)
library(readxl)
library(janitor)

# Define UI for application that draws a histogram
shinyUI(navbarPage(
theme = shinytheme("flatly"),

"Education and Political Leaning",
    
    # Application title
    tabPanel("About",
             p("Good Morning America", a("This is the link to my github.", href = "https://github.com/BobbyCurrent/Education_and_Politics_Final_Project")),
             h1("Good Job America"),
             p("My project is about the possible correlation between the quality of K-12 education in America and political party affiliation.
               I want to see if states with better education systems tend to lean toward the Democratic or Republican party in both national and statewide elections.
               It is commonly said by the left that people with better education tend to vote for more Democratic candidates, but I want to see if this prediction is true.
               I will be looking at how each state's education system is ranked and the composition of their representatives in both state and federal government to understand the relationship between the level of education and political leaning.")
             ),

    tabPanel("Presidential Elections by District",
             plotOutput("carPlot")
             
    ),

tabPanel("Election by Year and State",
         sidebarLayout(
             sidebarPanel(
                 checkboxGroupInput("years",
                                    "Presidential Election Year",
                                    choices = list("2000" = 2000,
                                               "2004" = 2004,
                                               "2008" = 2008,
                                               "2012" = 2012,
                                               "2016" = 2016),
                                    selected = 2000),
                 textInput("state",
                           "State Abbreviation",
                           value = "AL")
             ),
             mainPanel(
                 plotOutput("yearPlot")
             )
             ))

    
))
