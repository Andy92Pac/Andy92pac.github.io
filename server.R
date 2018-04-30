## server.R ##

setupMap = function(input, output) {
  
  capteurs = cap$find(fields = '{ "geometry.coordinates": 1, "fields.id_arc_tra": 1}')

  capteurs$lng = sapply(capteurs$geometry$coordinates, 
                        function(e) { 
                          if (!is.null(e)) return(e[1]); 
                          return(NA) 
                        })
  capteurs$lat = sapply(capteurs$geometry$coordinates, 
                        function(e) { 
                          if (!is.null(e)) return(e[2]); 
                          return(NA) 
                        })
  
  capteurs$id = sapply(capteurs$fields$id_arc_tra, 
                       function(e) { 
                         return(e)
                       })
  
  paris = leaflet() %>% addTiles %>%
    setView(lng = 2.34, lat = 48.855, zoom = 12) %>% 
    addProviderTiles(providers$OpenStreetMap.BlackAndWhite) 
  
  output$map = renderLeaflet({
    paris %>%
      addCircleMarkers(data = capteurs, lng = ~lng, lat = ~lat, layerId = ~id,
                       weight = 1, radius = 3, 
                       fillOpacity = 1, fillColor = "blue")
  }) 
  
  observe({
    click = input$map_marker_click
    if(is.null(click))
      return()
    
    output$mapCapteur = renderLeaflet({
      paris %>%
        addCircleMarkers(data = click, lng = ~lng, lat = ~lat, layerId = ~id,
                         weight = 5, radius = 6, 
                         fillOpacity = 1, fillColor = "blue") %>%
        setView(lng = click$lng, lat = click$lat, zoom = 16)
    })
    
    req <- GET(paste0("http://maps.googleapis.com/maps/api/geocode/json?latlng=",click$lat,",",click$lng,"&sensor=true"))
    res = content(req)
    
    output$capId = renderText(paste("Id du capteur : ", click$id))
    output$capAdresse = renderText(paste("Adresse du capteur : ", res$results[[2]]$formatted_address))
    output$capLat = renderText(paste("Latitude du capteur : ", click$lat))
    output$capLng = renderText(paste("Longitude du capteur : ", click$lng))
    updatePlotStats(input, output, click$id)
  })
}

updatePlotStats = function(input, output, id) {
  selectedCap <<- tra$find(query = paste0(' { "id": ', as.numeric(id), '}'))
  
  output$plotFromStart = renderPlot(
    ggplot(selectedCap, aes(date, tauxNum)) +
      geom_line() +
      theme_classic()
  )
  
  output$plotByYear = renderPlot(
    selectedCap %>% 
      mutate(annee = format(date, "%Y"), 
             jour = format(date, "%j")) %>%
      ggplot(aes(jour, tauxNum, col = annee)) +
      geom_line() +
      theme_classic()
  )
  
  output$plotByMonth = renderPlot(
    selectedCap %>% 
      mutate(heure = format(date, "%H"),
             mois = format(date, "%m")) %>%
      group_by(heure, mois) %>%
      summarise(moy = mean(tauxNum, na.rm = TRUE)) %>%
      ggplot(aes(heure, moy, col = mois, group = mois)) +
      geom_line() +
      theme_classic()
  )
  
  output$plotByDay = renderPlot(
    selectedCap %>% 
      mutate(heure = format(date, "%H"),
             jour = format(date, "%A")) %>%
      group_by(heure, jour) %>%
      summarise(moy = mean(tauxNum, na.rm = TRUE)) %>%
      ggplot(aes(heure, moy, col = jour, group = jour)) +
      geom_line() +
      theme_classic()
  )
  
} 

server <- function(input, output) { 
  
  setupMap(input, output)
  
}