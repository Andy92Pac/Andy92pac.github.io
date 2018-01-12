#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(leaflet)

# Define UI for application that draws a histogram
shinyUI(
  ui <- dashboardPage(
    dashboardHeader(title = "Basic dashboard"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
        menuItem("Options", tabName = "option", icon = icon("th")),
        sliderInput("slider", "Slider input:", 1, 100, 50)
      )
    ),
    dashboardBody(
      tabItems(
        # First tab content
        tabItem(tabName = "dashboard",
                fluidRow(
                  box(
                    width = 5, status = "info", height = 200,
                    title = "carte capteurs",
                    leafletOutput("Ma carte") 
                  ),
                  box(
                    width = 5, status = "info", height = 200,
                    title = "Tableau de données",
                    tableOutput("Datatable")
                  )
                )
                ),
        # Second tab content
        tabItem(tabName = "option",
                h2("Options tab content")
        )
        ),
      tabBox(
        side = "left", height = "250px", width = "250px",
        selected = "bails1",
        tabPanel("bails1", "bails 1 "),
        tabPanel("bails2", "bails 2"),
        tabPanel("Predictions", "série temporel forecast et compagnie")
      )
      )
    )
  )
