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
#I think the RDS is not working

presidential_elections <- read_csv("data/countypres_2000-2016.csv") %>%
    mutate(vote_prop = (candidatevotes / totalvotes)) %>%
    mutate(percent_won = (vote_prop * 100)) %>%
    filter(party %in% c("democrat", "republican")) %>%
    pivot_wider(id_cols = c(FIPS, year, state),
                names_from = party,
                values_from = c(percent_won, candidate))



students_2012 <- read_csv("data/non_fiscal_2012.csv", col_types = cols(MEMBER = col_double(),
                                                                           LEAID = col_double())) %>%
    clean_names() %>%
    select(member, leaid) 

spending_2012 <- read_csv("data/district_spending_2011.csv", 
                          col_types = cols(name = col_character(),
                                           stname = col_character(),
                                           stabbr = col_character())) %>%
    clean_names() %>%
    left_join(students_2012, by = "leaid") %>%
    select(conum, 
           name, 
           stname, 
           stabbr, 
           totalrev,
           totalexp, 
           tlocrev, 
           tstrev, 
           tfedrev,
           leaid,
           total_students = member) %>%
    mutate(year = 2012) %>%
    mutate(percent_local = ((tlocrev / totalrev) * 100)) %>%
    mutate(percent_federal = ((tfedrev / totalrev) * 100)) %>%
    mutate(percent_state = ((tstrev / totalrev) * 100)) %>%
    filter(!is.na(total_students)) %>%
    mutate(per_capita_rev = (totalrev / total_students)) %>%
    filter(total_students > 0) %>%
    mutate(per_capita_exp = (totalrev / total_students))



students_2008 <- read_csv("data/non_fiscal_2008.csv", col_types = cols(PK1207 = col_double(),
                                                                           LEAID = col_double())) %>%
    clean_names() %>%
    select(pk1207, leaid)

spending_2008 <- read_csv("data/district_spending_2008.csv",
                          col_types = cols(name = col_character(), 
                                           stname = col_character(), 
                                           stabbr = col_character())) %>%
    clean_names() %>%
    left_join(students_2008, by = "leaid") %>%
    select(conum, 
           name, 
           stname, 
           stabbr, 
           totalrev, 
           totalexp, 
           tlocrev,
           tstrev, 
           tfedrev,
           leaid,
           total_students = pk1207) %>%
    mutate(year = 2008) %>%
    mutate(percent_local = ((tlocrev / totalrev) * 100)) %>%
    mutate(percent_federal = ((tfedrev / totalrev) * 100)) %>%
    mutate(percent_state = ((tstrev / totalrev) * 100)) %>%
    filter(!is.na(total_students)) %>%
    mutate(per_capita_rev = (totalrev / total_students)) %>%
    filter(total_students > 0) %>%
    mutate(per_capita_exp = (totalrev / total_students))




spending_2004 <- read_csv("data/district_spending_2004.csv",
                          col_types = cols(name = col_character(),
                                           stname = col_character(),
                                           stabbr = col_character())) %>%
    clean_names() %>%
    select(conum, 
           name, 
           stname, 
           stabbr, 
           totalrev, 
           totalexp, 
           tlocrev, 
           tstrev, 
           tfedrev,
           leaid) %>%
    mutate(year = 2004) %>%
    mutate(percent_local = ((tlocrev / totalrev) * 100)) %>%
    mutate(percent_federal = ((tfedrev / totalrev) * 100)) %>%
    mutate(percent_state = ((tstrev / totalrev) * 100))



students_2016 <- read_csv("data/membership_2016.csv",
                          col_types = cols(TOTAL = col_double(),
                                           LEAID = col_double())) %>%
    clean_names() %>%
    select(total, leaid)

spending_2016 <- read_csv("data/district_spending_2016.csv", 
                          col_types = cols(name = col_character(),
                                           stname = col_character(),
                                           stabbr = col_character())) %>%
    clean_names() %>%
    left_join(students_2016, by = "leaid") %>%
    select(conum,
           name,
           stname,
           stabbr,
           totalrev,
           totalexp,
           tlocrev,
           tfedrev,
           tstrev,
           leaid,
           total_students = total) %>%
    mutate(year = 2016) %>%
    mutate(percent_local = ((tlocrev / totalrev) * 100)) %>%
    mutate(percent_federal = ((tfedrev / totalrev) * 100)) %>%
    mutate(percent_state = ((tstrev / totalrev) * 100)) %>%
    filter(!is.na(total_students)) %>%
    mutate(per_capita_rev = totalrev / total_students) %>%
    filter(total_students > 0) %>%
    mutate(per_capita_exp = (totalrev / total_students))



joined_temp <- bind_rows(spending_2004, spending_2008, spending_2012, spending_2016)



spending_2000 <- read_csv("data/district_spending_2000.csv",
                          col_types = cols(name = col_character(),
                                           stname = col_character(),
                                           stabbr = col_character())) %>%
    clean_names() %>%
    select(name, 
           stname, 
           stabbr, 
           totalrev, 
           totalexp, 
           tlocrev, 
           tstrev, 
           tfedrev,
           leaid) %>%
    left_join(joined_temp, by = "name") %>%
    filter(!is.na(conum)) %>%
    distinct(conum, .keep_all = TRUE) %>%
    select(name, 
           stname = stname.x, 
           stabbr = stabbr.x, 
           totalrev = totalrev.x, 
           totalexp = totalexp.x, 
           tlocrev = tlocrev.x, 
           tstrev = tstrev.x, 
           tfedrev = tfedrev.x,
           conum,
           leaid = leaid.x) %>%
    mutate(year = 2000) %>%
    mutate(percent_local = ((tlocrev / totalrev) * 100)) %>%
    mutate(percent_federal = ((tfedrev / totalrev) * 100)) %>%
    mutate(percent_state = ((tstrev / totalrev) * 100))



final_data <- bind_rows(joined_temp, spending_2000) %>%
    left_join(presidential_elections, by = c("conum" = "FIPS", "year"))


#This might just be extraneous, but we will see.

saveRDS(final_data, file = "saved_file")

readRDS("saved_file")


final_data_million <- 
    final_data %>%
    filter(year %in% c(2008, 2012, 2016)) %>%
    mutate(Total_Expenditure = (totalexp / 1000000)) %>%
    mutate(Total_Revenue = (totalrev / 1000000)) %>%
    mutate(Total_State_Revenue = (tstrev / 1000000)) %>%
    mutate(stname = toupper(stname)) %>%
    mutate(Per_Capita_Revenue = (per_capita_rev / 1000)) %>%
    mutate(Per_Capita_Expenditure = (per_capita_exp / 1000)) %>%
    mutate(Total_Students = total_students)

#This also might be extra, but we'll see.

saveRDS(final_data_million, file = "stan_data")

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
    
    #Per Capita spending table here
    
    output$stanPrint <- render_gt({
        other_stan %>%
            tbl_regression(intercept = TRUE,
                           exponentiate = TRUE,
                           estimate_fun = function(other_stan)
                               style_sigfig(other_stan, digits = 9)) %>%
            as_gt() %>%
            tab_header(subtitle = "Effect of Total Students and Spending Per Capita on Democratic Vote Share",
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
    
    #Total spending table, forgot to explicitly say it in title.
    
    output$totalPrint <- render_gt({
        total_stan %>%
            tbl_regression(intercept = TRUE,
                           exponentiate = TRUE,
                           estimate_fun = function(total_stan)
                               style_sigfig(total_stan, digits = 9)) %>%
            as_gt() %>%
            tab_header(subtitle = "Effect of Total School Spending on 
             Democratic Vote Share",
                       title = "Regression of Democratic Vote Share in Presidential 
             Elections")
    })
    
    

})
