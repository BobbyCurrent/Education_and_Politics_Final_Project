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
             plotOutput("carPlot"),
             h1("Interpretation"),
             p("These graphs have the amount of money spent on education in each school district on the x-axis and the percentage of the vote that Democratic presidential candidates get in those districts on the y-axis.
               The line helps reveal the correlation that, as a trend, districts that spend more money on education tend to vote more for Democrats that Republicans in Presidential elections.
               It an be seen with each election from 2000 to 2016 that this trend tends to be the same across the board."),
             
               p("One important disticntion that must be made is that these graphs are looking at the raw amount of money spent.
               This means that the graphs are actually comparing large and small school systems more so than the amount of money actually being spent per student, which would indicate the quality of education.
               With this in mind, the graph tells us that larger school systems, likely from states such as California and New York, are more likely to vote Democratic than smaller ones, which are more likely to be from states like Mississippi and Wyoming.
               Beyond a state divide, this could also speak to an urban rural divide, as urban areas are more likely to have larger school sysyems than rural ones, resutling in more money being spent in urban areas with the same quality of education as a rural area that spends less.
               Since urban areas are more likely to vote for Democrats, this trend makes sense.")
             
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
