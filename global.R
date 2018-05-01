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

<<<<<<< HEAD

plotByDay = renderPlot(
  selectedCap %>% 
    mutate(heure = format(date, "%H"),
           jour = format(date, "%A")) %>%
    group_by(heure, jour) %>%
    summarise(moy = mean(tauxNum, na.rm = TRUE)) %>%
    ggplot(aes(heure, moy, col = jour, group = jour)) +
    geom_line() +
    theme_classic()
)
=======
>>>>>>> eca898184517099666095100b42c2a1b6fbcb44a
