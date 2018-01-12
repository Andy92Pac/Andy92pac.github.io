#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(mongolite)

# Database connection
conCapteurs = mongo(collection = "capteurs", db="trafic", url = "mongodb://193.51.82.104:2343")
conCapteurs_geo = mongo(collection = "capteurs_geo", db="trafic", url = "mongodb://193.51.82.104:2343")
conTrafic = mongo(collection = "trafic", db="trafic", url = "mongodb://193.51.82.104:2343")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
  
})
