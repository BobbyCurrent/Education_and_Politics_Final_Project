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

# Define UI for application that draws a histogram
shinyUI(navbarPage(
theme = shinytheme("flatly"),

"Education and Political Leaning",
    
    # Application title
    tabPanel("About",
             p("Good Morning America", a("Link", href = "https://datasetsearch.research.google.com/search?query=education%20spending&docid=aucTpd7EMjRiMgOaAAAAAA%3D%3D")),
             h1("Don't reelect the Orange"),
            
             ),

    tabPanel("Republicans and Democrats",
             plotOutput("carPlot")
             
    )

    
))
