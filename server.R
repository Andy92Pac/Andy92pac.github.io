## server.R ##

setupMap = function(input, output) {
  
  capteurs = cap$find(fields = '{ "geometry.coordinates": 1}')
  
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
  
  paris = leaflet() %>% addTiles %>%
    setView(lng = 2.34, lat = 48.855, zoom = 12) %>% 
    addProviderTiles(providers$OpenStreetMap.BlackAndWhite) 
  
  output$map = renderLeaflet({
    paris %>%
      addCircleMarkers(data = capteurs, lng = ~lng, lat = ~lat, layerId = ~`_id`,
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
    
    output$capId = renderText(paste("Id du capteur : ", click$id))
    output$capLat = renderText(paste("Latitude du capteur : ", click$lat))
    output$capLng = renderText(paste("Longitude du capteur : ", click$lng))
  })
}

server <- function(input, output) { 
  
  # output$search_plot <- renderUI({
  #  searchInput(inputId = "Id009", 
  #              placeholder = "Entrer l'adresse",
  #              btnSearch = icon("search"), 
  #              btnReset = icon("remove"), 
  #              value='',
  #              width = "100%")
  #})
  
  setupMap(input, output)
  
}