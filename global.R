library(mongolite)
library(jsonlite)
library(dplyr)
library(ggplot2)
library(leaflet)
library(sp)
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(shinycssloaders)
library(httr)
library(forecast)
library(shinyalert)

cap = mongo(collection = "capteurs", db = "trafic", 
            url = "mongodb://193.51.82.104:2343")
tra = mongo(collection = "trafic", db = "trafic", 
            url = "mongodb://193.51.82.104:2343")

