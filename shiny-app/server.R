#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#This read it in but it does not move that fast still.
#I don't know if it is because of the amount of data or if it is
#just slow.

readRDS("saved_file")

readRDS("stan_data")



other_stan <- stan_glm(data = final_data_million,
                       formula = percent_won_democrat ~ Per_Capita_Expenditure:Per_Capita_Revenue 
                       + Total_Students,
                       refresh = 0)

total_stan <- stan_glm(data = final_data_million,
                       formula = percent_won_democrat ~ Total_Revenue + Total_Expenditure,
                       refresh = 0)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$firstPlot <- renderPlot({
        final_data %>%
            #filter(year == 2016) %>%
            #filter(stabbr == "SC") %>%
            ggplot(aes(x = totalexp, y = percent_won_democrat)) +
            geom_point(alpha = 0.25) +
            geom_smooth(method = "lm") +
            scale_x_log10() +
            facet_wrap(~ year) +
            labs(title = "School Spending and Democratic Vote Share in Presidential Elections", 
                 subtitle = "2000 to 2016 Presidential Elections", 
                 x = "Education Spending Per District", 
                 y = "Percent of vote for Democratic Candidate") +
            theme_bw()
    })
    
    output$yearPlot <- renderPlot({
        p <- final_data %>%
            filter(year %in% input$years) %>%
            filter(stabbr == input$state) %>%
            ggplot(aes(x = totalexp, y = percent_won_democrat)) +
            geom_point(alpha = 0.35) +
            geom_smooth(method = "lm") +
            scale_x_log10() +
            facet_wrap(~ year) +
            labs(title = "School Spending and Democratic Vote Share in Presidential Elections", 
                 subtitle = "Presidential Elections Per Year and State", 
                 x = "Total Education Spending Per District", 
                 y = "Percent of vote for Democratic Candidate") +
            theme_bw()
        
        p
    })
    
    output$virginiaPlot <- renderPlot({
        final_data %>%
            #filter(year == 2016) %>%
            filter(stabbr == "VA") %>%
            ggplot(aes(x = totalexp, y = percent_won_democrat)) +
            geom_point(alpha = 0.35) +
            geom_smooth(method = "lm") +
            scale_x_log10() +
            facet_wrap(~ year) +
            labs(title = "School Spending and Democratic Vote Share in Presidential Elections", 
                 subtitle = "Democratic vote share in Virginia since the 2000 election", 
                 x = "Education Spending Per District", 
                 y = "Percent of vote for Democratic Candidate") +
            theme_bw()
        
        
    })
    
    output$ohioPlot <- renderPlot({
        final_data %>%
            #filter(year == 2016) %>%
            filter(stabbr == "OH") %>%
            ggplot(aes(x = totalexp, y = percent_won_democrat)) +
            geom_point(alpha = 0.35) +
            geom_smooth(method = "lm") +
            scale_x_log10() +
            facet_wrap(~ year) +
            labs(title = "School Spending and Democratic Vote Share in Presidential Elections", 
                 subtitle = "Democratic vote share in Ohio since the 2000 election", 
                 x = "Education Spending Per District", 
                 y = "Percent of vote for Democratic Candidate") +
            theme_bw()
        
        
    })
    
    output$capitaPlot <- renderPlot({
        final_data %>%
            filter(year %in% input$years2) %>%
            filter(stabbr == input$state2) %>%
            ggplot(aes(x = per_capita_exp, y = percent_won_democrat)) +
            geom_point(alpha = 0.35) +
            geom_smooth(method = "lm") +
            scale_x_log10() +
            facet_wrap(~ year) +
            labs(title = "School Spending and Democratic Vote Share in Presidential Elections",
                 x = "Education Spending Per Student Per District", 
                 y = "Percent of vote for Democratic Candidate") +
            theme_bw()
    })
    
    output$nationalPlot <- renderPlot({
        final_data %>%
            filter(year %in% c(2008, 2012, 2016)) %>%
            ggplot(aes(x = per_capita_exp, y = percent_won_democrat)) +
            geom_point(alpha = 0.25) +
            geom_smooth(method = "lm") +
            scale_x_log10() +
            facet_wrap(~ year) +
            labs(title = "School Spending and Democratic Vote Share in Presidential Elections", 
                 subtitle = "Democratic vote share in United States since the 2008 election", 
                 x = "Education Spending Per Student Per District", 
                 y = "Percent of vote for Democratic Candidate") +
            theme_bw()
    })
    
    
    output$stanPrint <- render_gt({
        other_stan %>%
            tbl_regression(intercept = TRUE,
                           exponentiate = TRUE,
                           estimate_fun = function(other_stan)
                               style_sigfig(other_stan, digits = 9)) %>%
            as_gt() %>%
            tab_header(subtitle = "Effect of Total Students and School Spending on Democratic Vote Share",
                       title = "Regression of Democratic Vote Share in Presidential Elections")
        
    })
    
    
    output$californiaPlot <- renderPlot({
        final_data %>%
            filter(year %in% c(2008, 2012, 2016)) %>%
            filter(stabbr == "CA") %>%
            ggplot(aes(x = per_capita_exp, y = percent_won_democrat)) +
            geom_point(alpha = 0.35) +
            geom_smooth(method = "lm") +
            scale_x_log10() +
            facet_wrap(~ year) +
            labs(title = "School Spending and Democratic Vote Share in Presidential Elections", 
                 subtitle = "Democratic vote share in California since the 2008 election", 
                 x = "Education Spending Per Student Per District", 
                 y = "Percent of vote for Democratic Candidate") +
            theme_bw()
    })
    
    
    output$texasPlot <- renderPlot({
        final_data %>%
            filter(year %in% c(2008, 2012, 2016)) %>%
            filter(stabbr == "TX") %>%
            ggplot(aes(x = per_capita_exp, y = percent_won_democrat)) +
            geom_point(alpha = 0.35) +
            geom_smooth(method = "lm") +
            scale_x_log10() +
            facet_wrap(~ year) +
            labs(title = "School Spending and Democratic Vote Share in Presidential Elections", 
                 subtitle = "Democratic vote share in Texas since the 2008 election", 
                 x = "Education Spending Per Student Per District", 
                 y = "Percent of vote for Democratic Candidate") +
            theme_bw()
    })
    
    
    output$totalPrint <- render_gt({
        total_stan %>%
            tbl_regression(intercept = TRUE,
                           exponentiate = TRUE,
                           estimate_fun = function(total_stan)
                               style_sigfig(total_stan, digits = 9)) %>%
            as_gt() %>%
            tab_header(subtitle = "Effect of School Spending on 
             Democratic Vote Share",
                       title = "Regression of Democratic Vote Share in Presidential 
             Elections")
    })
    
    

})
