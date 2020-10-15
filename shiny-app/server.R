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
    select(STNAME, R1A)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$carPlot <- renderPlot({
        school_spending_2017_2018 %>%
            ggplot(aes(x = STNAME, y = R1A)) +
            geom_col() +
            labs(x = "State Name", y = "Some Kind of Spending") +
            theme(axis.text.x = element_text(angle = 90, hjust = 1))
    
       
    })

})
