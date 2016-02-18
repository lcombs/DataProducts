# server

function(input, output, session){
        terms <- reactive({
                input$update
                
                isolate({
                        withProgress({
                                setProgress(message = "Processing corpus...")
                                getTermMatrix(input$selection)
                        })
                })
        })
        
        
        
        wordcloud_rep <- 
                repeatable(wordcloud)
        
        output$plot <- 
                renderPlot({
                        v <- terms()
                        wordcloud_rep(names(v), v, min.freq = input$freq,
                                      scale = c(8, 2),
                                      colors = brewer.pal(9, "Greens")[c(4:9)])
                })
        
}
