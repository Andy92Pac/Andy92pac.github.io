library(mongolite)
library(jsonlite)
library(dplyr)
library(ggplot2)
library(leaflet)
library(sp)
library(shiny)
library(shinydashboard)

cap = mongo(collection = "capteurs", db = "trafic", 
            url = "mongodb://193.51.82.104:2343")
tra = mongo(collection = "trafic", db = "trafic", 
            url = "mongodb://193.51.82.104:2343")

toJSON(cap$find(limit = 1), pretty = T)





