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
             h1("Education and Politics"),
             
             p("My project is about the possible correlation between the quality of K-12 education in America and political party affiliation.
               I want to see if states with better funded education systems tend to lean toward the Democratic or Republican party in presidential elections.
               It is commonly said by the left that higher educated people tend to vote for more Democratic candidates, but I want to see if this claim is true.
               I will be looking at how much each school district spends on education and the percentage of their votes that went to the Democratic candidate in the 2000, 2004, 2008, 2012, and 2016 presidential elections."),
             
             p("I got my data on presidential elections from the Harvard Dataverse.
               The link to that data is", a("here.", href = "https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/VOQCHQ"),
               "All the data I used about education funding and statistics came from the NCES (National Center for Education Statistics).
               The link to my education data is", a("here.", href = "https://nces.ed.gov/ccd/files.asp#Fiscal:2,LevelId:2,SchoolYearId:32,Page:1")),
             
             p("The link to my git repository of this project is", a("here.", href = "https://github.com/BobbyCurrent/Education_and_Politics_Final_Project"),
               "This repository has record of how the project was created and has all of the background information in it.
               It shows how the data was cleaned, how the graphs were made, and everything in between."),
             
             h2("About Me"),
             
             p("My name is Bobby Current and I am a first year student at Harvard College.
               My concentration will most likely either be government or history, with one of them possibly being a secondary.
               You can reach me at my email, bobby_current@college.harvard.edu.")
             
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
             ),
             p("These graphs let you see the possible correlation between school funding and the Democratic vote share across five presidential elections in any state in the union and the District of Columbia.
               Each state will look a little different across time, so the states of Virginia and Ohio have been given as examples below with their interpretations.
               It sohlud be noted that there is less data for the 2000 school year, as either less districts were inclined to report their information that year or there were less districts to report that information in the first place, if not some combination of the two.
               This means that the trends shown for the 2000 election should be taken with a grain of salt, as they are not as exact as the ones created from later elections."),
         
             mainPanel(
                 plotOutput("virginiaPlot")
             ),
         p("This plot looks specifically at Virginia across five different elections.
           Virginia is an interesting state because of its relatively recent shift toward the left.
           In both 2000 and 2004, Virginia voted for George Bush, a Republican, for the presidency, but from 2008 onwards the state has voted for Democratic candidates consistently.
           I used Virginia as an example here because of the clear difference in the plots from 2000 and 2004 to the ones from 2008 through 2016.
           In the 2000 election, there was barely any correlation between the amount of raw dollars spent on education per district and the rates at which people voted for Democratic candidates.
           The same is true for 2004.
           This changes in 2008, however, where there is suddenly a clear trend that the more a district spends on education, the more they voted for a Democratic candidate.
           This makes Virginia an interesting example of how education spending may have impacted voting in these districts, with no correlation being there when the state went red and a strong one being there when the state went blue.
           This could simply just be down to more people voting for Democrats in those elections too though."),
         
             mainPanel(
                 plotOutput("ohioPlot")
             ),
         p("This plot looks at Ohio across different elections, with a negative trend existing for this state.
           What is interesting is that, while Ohio voted for George Bush in 2000 and 2004, the state voted for Barack Obama in 2008 and 2012.
           This means that, wven while the state went to the Democratic Party, there was a clear negative correlation between the amount of raw dollars being spent on education and the percentage of the vote that Democrats get.
           This means that the districts that spend the most amount of money on education do not tend to favor Democrats, which goes directly against the claim that areas with better funded education systems tend to vote for the left.
           As this is looking at the total amount of money spent instead of the amount spent per student, it is impossible to tell if the graph would look the same if the quality of education were considered instead of just the raw funding.")
         
             ),

tabPanel("Vote Share Per Capita",
         sidebarLayout(
             sidebarPanel(
                 checkboxGroupInput("years2",
                                    "Election Year",
                                    choices = list("2008" = 2008,
                                                   "2012" = 2012,
                                                   "2016" = 2016),
                                    selected = 2008),
                 textInput("state2",
                           "State Abbreviation",
                           value = "AL")
             ),
             mainPanel(
                 plotOutput("capitaPlot")
             )
             ),
             p("This plot is looks at the possible correlations between the amount spent on education per district and the percentage of the vote that Democrats win.
               This graph is a lot better than the ones looking at total spending because the spending per capita can better indicate the quality of education instead of the size of a school disrict."),
             
             mainPanel(
                 plotOutput("nationalPlot")
             ),
         p("This is the version of the spending per capita graph.
           It can be seen that the spending per capita of the different school districts is more similar than their total spending, likely because of the difference in district sizes.
           The correlation between spending per capita and the Democratic vote share also seems to be more strong, implying that the quality of education, which is heavily influenced by spending per capita, has a large affect on voting patterns.")
    
)


    
))
