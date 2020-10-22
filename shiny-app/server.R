#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


school_spending_2017_2018 <-
    spending_data_2018 <-
    read_excel("data/Stfis180_1a.xlsx") %>%
    group_by(STNAME) %>%
    select(STNAME, E11A)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$carPlot <- renderPlot({
        school_spending_2017_2018 %>%
            ggplot(aes(x = STNAME, y = E11A)) +
            geom_col() +
            labs(x = "State", y = "Total Amount Paid", title = "The Total Amount Paid to Teachers in Regular Education Programs by State", subtitle = "2017 - 2018 School Year") +
            theme(axis.text.x = element_text(angle = 90, hjust = 1))
    
       
    })

})
