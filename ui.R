library(shiny)
library(markdown)

# ui 
fluidPage(
        
        titlePanel("CFPB Consumer Complaints"),
        
        sidebarLayout(
                sidebarPanel(
                        selectInput("selection", 
                                    "Select a product type:", 
                                    choices = cc$Product  %>% as.character()  %>% 
                                            unique()  %>% sort()),
                        actionButton("update", "Render"),
                        hr(),
                        sliderInput("freq", 
                                    "Minimum Frequency:", 
                                    min = 1, max = 500, value = 100)),
                mainPanel(
                        tabsetPanel(
                                tabPanel("WordCloud", 
                                         plotOutput("plot", 
                                                    height = 1000, 
                                                    width = 1000)),
                                tabPanel("About",
                                         includeMarkdown("about.md"))
                        )
                )
        )
)