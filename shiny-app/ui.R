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
library(gtsummary)
library(gt)
library(broom.mixed)
library(rstanarm)

#So I did decicde to go with the alpha argument for everything.
# Define UI for application that draws a histogram
shinyUI(navbarPage(
theme = shinytheme("flatly"),

"Education and Political Leaning",
    
    # Application title

    tabPanel("About",
             h1("Partisan Spending"),
             
#Partisan Spending is a much better title than whatever I had before.
             
             p("My project is about the possible correlation between the amount of money spent on K-12 education in America and voting patterns.
               I want to see if states with better funded education systems tend to lean toward the Democratic or Republican party in presidential elections.
               It is commonly said by the left that higher educated people tend to vote for more Democratic candidates, while less educated people tend to vote for Republicans.
               While this is a very partisan claim, I wanted to see if there was any truth to the statement.
               To do this, I will be looking at how much each school district spends on education and the percentage of their votes that went to the Democratic candidate in the 2000, 2004, 2008, 2012, and 2016 presidential elections."),
             
             p("I got my data on presidential elections from the Harvard Dataverse.
               The link to that data is", a("here.", href = "https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/VOQCHQ"),
               "All the data I used about education funding and statistics came from the NCES (National Center for Education Statistics).
               The link to my education data is", a("here.", href = "https://nces.ed.gov/ccd/files.asp#Fiscal:2,LevelId:2,SchoolYearId:32,Page:1")),
             
             p("The link to my github repository of this project is", a("here.", href = "https://github.com/BobbyCurrent/Education_and_Politics_Final_Project"),
               "This repository has record of how the project was created and has all of the background information in it.
               It shows how the data was cleaned, how the graphs were made, and everything in between."),
             
             h2("About Me"),
             
             #I could have done a link to my email, but I'm not sure how that 
             #would work. I also just don't want to, they can copy and paste.
             
             p("My name is Bobby Current and I am a first year student at Harvard College.
               My concentration will most likely either be government or history, with one of them possibly being a secondary.
               You can reach me at my email, bobby_current@college.harvard.edu.")
             
             ),

#Panel for first graph: raw spending national plot

    tabPanel("Presidential Elections by District",
             
#Almost forgot to have mainPanel there
             h3("Total National Spending"),
             mainPanel(
                 plotOutput("firstPlot")
                 
#Thought I should change that from carPlot to something else.

                 ),
             
             p("The graph to the left has the total amount of money spent on education in each school district on the x-axis and the percentage of the vote that Democratic presidential candidates get in those districts on the y-axis.
               The line helps reveal the correlation that, as a trend, districts that spend more money on education tend to vote more for Democrats that Republicans in Presidential elections.
               It an be seen with each election from 2000 to 2016 that this trend tends to be the same across the board."),
             
               p("One important disticntion that must be made is that these graphs are looking at the raw amount of money spent, not spending per capita.
               This means that the graphs are likely comparing large and small school systems instead of the amount of money actually being spent per student, which is a better indicator for education funding.
               With this in mind, the graph tells us that larger school systems, likely from states such as California and New York, are more likely to vote Democratic than smaller ones, which are more likely to be from states like Mississippi and Wyoming.
               Beyond a state divide, this could also speak to an urban rural divide, as urban areas are more likely to have larger school sysyems than rural ones, resutling in more money being spent in urban areas with the same quality of education as a rural area that spends less.
               Since urban areas are more likely to vote for Democrats, this trend makes sense."),

#I added the plot below here instead of having it with the other per capita 
#plots. It goes here much better than it does there.
                
            h3("Per Capita National Spending"),
            mainPanel(
                plotOutput("nationalPlot")
                ),
            p("The graph to the left is the national version of the spending per capita graph.
            It can be seen that the spending per capita of the different school districts is more similar than their total spending, likely because of the difference in district sizes.
            The correlation between spending per capita and the Democratic vote share also seems to be more strong, implying that the quality of education, which is heavily influenced by spending per capita, has a large affect on voting patterns.
            Looks can be quite decieving, however, as the actual points of the graph tell otherwise.
            With the points bein g clustered around one area on the x-axis, it seems that school districts across the country tend to spend around the same amount of money per student on average.
            With this being the case, it is impossible for there to be nearly as strong a correlation as the line would suggest.
            The reality is that the line is created using the outlier data, as the graph tries really hard to make it in the first place.")
             
    ),

#Panel for raw spending interactive plot

tabPanel("Election by Year and State",
         sidebarLayout(
             sidebarPanel(
                 
#This part gives it a checkbox with the years
                 
                 checkboxGroupInput("years",
                                    "Presidential Election Year",
                                    choices = list("2000" = 2000,
                                               "2004" = 2004,
                                               "2008" = 2008,
                                               "2012" = 2012,
                                               "2016" = 2016),
                                    selected = 2000),
                 
# This part allows for the state name to be put in
                 
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
               It should be noted that there is less data for the 2000 school year, as either less districts were inclined to report their information that year or there were less districts to report that information in the first place, if not some combination of the two.
               This means that the trends shown for the 2000 election should be taken with a grain of salt, as they are not as exact as the ones created from later elections."),
         
            h1("Examples"),
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
           This means that, while the state went to the Democratic Party, there was a clear negative correlation between the amount of raw dollars being spent on education and the percentage of the vote that Democrats get.
           This means that the districts that spend the most amount of money on education do not tend to favor Democrats, which goes directly against the claim that areas with better funded education systems tend to vote for the left.
           As this is looking at the total amount of money spent instead of the amount spent per student, it is impossible to tell if the graph would look the same if the relative amount spent were considered instead of just the raw funding.")
         
             ),

#Panel for per capita spending interactive plot

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
               This graph is a lot better than the ones looking at total spending because the spending per capita can better indicate the relative amount spent on education instead of the size of a school disrict."),
         
         h1("Examples"),
         mainPanel(
             plotOutput("californiaPlot")
         ),
         p("The first graph to the left is the California spending per capita plot.
           It is interesting because it shows that California, a safe Democrat state, does not have much of a correlation between spending and Democratic vote share.
           This could be because Californians tend to vote blue on such a scale that the actual amount of money schools get per student does not matter for presidential elections, or it could show that there is little to no correlation between school funding and voting patterns."),
         
         mainPanel(
             plotOutput("texasPlot")
         ),
         p("The second graph is the Texas spending per capita plot.
           Something notable about this plot is that while the line appears to show a negative correlation between Democratic vote share and per capita school spending, the actual points reveal no such thing.
           The points are clustered around one area on the x-axis, which means that Texas school districts tend to spend about the same amount on education for each student.
           With this being the case, it is clear that Texas does not reveal a correlation between higher spending per student and more votes going to the Democratic Party.")
      
         #I had the national per capita plot here, I might move it.
         #I moved it, it looks better there.
        
         
    
),

#Panel for table and interpretation

tabPanel("Analysis",
         h1("Spending Per Student"),
         mainPanel(
             gt_output("stanPrint")
         ),
         p("This table predicts the mathematical effect the amount of students, the per capita revenue, and the per capita expenditure has on Demcratic vote share.
         The percapita spending, both revenue and expenditures, are looked at by thousands of dollars as a unit of analysis, as a single dollar is highly unlikely to have an affect when so much money is being spent.
           The intercept is the Democratic vote share.
           This means that, without the amount of students or per capita spending being considered, Democrats are predicted to win an average of 44% of the popular vote in school districts.
           This makes sense, as more states vote Republican than Democrat on the presidential level and Democratic areas tend to be concentrated in cities rather than spread out across the countryside."),
          
           p("The variable 'Total_Students' denotates the total amount of students in the individual school district.
           When the amount of students are considered, the Democratic vote share is predicted to increase by 0.00013 percent.
           This increase is negligible, as it has no real impact on the amount of votes Democrats get."),
           
           p("The variable 'Per_Capita_Expenditure*Per_Capita_Revenue' is the interaction term.
           It shows the impact of including both the per capita revenue and spending on voting patterns.
           This impact, a 0.00000006 percent change to the intercept, is also negligible, as it has even less of a predicted effect than the amount of students did on voting patterns."),
        
         #Added another plot, and some headers
         #Might need to say something about unit of analysis
         
          h1("Total Spending"),
         mainPanel(
             gt_output("totalPrint")
         ),
         p("As with the table above, there is little to no effect of school spending on voting patterns. 
         The Intercept is still the Democratic Vote Share in presidential elections, and the variables changed from the spending per captia to the total spending, with the amount ot students not being  factor.
         It can be seen that the total spending and revenue, which are counted by the millions in this table instead of single dollars or thousands of dollars, both have a negligible influence on Democratic vote share.
         The table predicts that the Democrats only get 0.0446 percent more of the vote when school revenue is considered and they lose 0.0319 percent of the vote when the spending is considered.
         This means that there is little to no effect of total school spending and revenue on voting patterns in America."),
         
         p("Taken as a whole, it seems that neither the amount of students, the total revenue nor spending per student is predicted to have an effect on Democratic vote share in presidential elections.")
    
),

#Panel for final thoughts and results

tabPanel("Conclusions",
         h1("Results"),
         
         p("With everything taken as a whole, it seems that school spending does not have much of an impact on voting patterns in America.
           With the per capita spending, which is the best way to show education funding, showing no correlation between higher spending and an increased Democratic vote share, it seems that voting patterns are not effected by education funding alone.
           This means that the claim that the more education funding leads to more votes for Democrats is false, as is any claim that less education spending favors Republicans.
           Based on the data collected, there is no correlation between spending and voting patterns whatsoever."),
         
         h2("Further Study"),
         
         p("Even though education funding does not have much of an effect on voting patterns, it has been shown in exit polls that people with higher levels of education tend to vote more to the left than the right.
           If one wanted to look more into the impact education has on voting patterns, it would be better to look at the quality of education rather than its funding.
           It has been shown that funding does not have much of an effect on the quality of education beyond a certain point, so other factors would have to be examined in further study.
           This could be anything from standardized test scores and  the amount of extra curriculars to the length of the school day.
           Those factors would likely give a better approximation of the quality of k-12 education than spending does.")
    
)


    
))
