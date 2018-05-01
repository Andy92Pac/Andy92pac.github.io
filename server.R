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

if (!"debit" %in% colnames(selectedCap) | !"tauxNum" %in% colnames(selectedCap) | !"taux" %in% colnames(selectedCap)){
    shinyalert("Ce capteur comporte peu d'informations pour être analysé, veuillez en sélectionner un autre")
}else {
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
  
  debit_pred <- (head(selectedCap %>% select(debit),150))
  debit_pred = unlist(debit_pred)
  debit_pred = gsub(",",".",debit_pred)
  debit_pred = as.numeric(debit_pred)
  deb_na <- sum(is.na(debit_pred))
  if (deb_na > 60){
    shinyalert("Ce capteur comporte peu d'informations pour pouvoir faire une prédiction fiable, sélectionnez un autre capteur",type = "error")
  } else {
    ts.debit_pred <- ts(debit_pred,frequency = 24)
    ts.debit_pred_Sa <- diff(ts.debit_pred)
    ar <- auto.arima(ts.debit_pred_Sa)
    f <- forecast(ar,h=24)
    output$predictDebitByDay = renderPlot(
      plot(f,xlab="Jours",ylab="Fréquences",main = "Prédiction du débit du capteur sélectionné en fonction du temps")
    )
  }
  
  Tx_pred <- (head(selectedCap %>% select(taux),150))
  
  Tx_pred = unlist(Tx_pred)
  Tx_pred = gsub(",",".",Tx_pred)
  Tx_pred = as.numeric(Tx_pred)
  Tx_na <- sum(is.na(Tx_pred))
  if (Tx_na > 60){
    shinyalert("Ce capteur comporte peu d'informations pour pouvoir faire une prédiction fiable, sélectionnez un autre capteur",type = "error")
  } else {
    ts.Tx_pred <- ts(Tx_pred, frequency = 24)
    ts.Tx_pred_Sa <- diff(ts.Tx_pred)
    Tx.ar <- auto.arima(ts.Tx_pred_Sa)
    Tx.f <- forecast(Tx.ar,h=24)
    output$predictTxByDay = renderPlot(
      plot(Tx.f,xlab="Jours",ylab="Fréquences",main = "Prédiction du taux du capteur sélectionné en fonction du temps")
    )
  }
  
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
  }
  
   

server <- function(input, output) { 
  
  output$pres = renderUI(HTML('<hr>
<p>title: &quot;Trafic mongo&quot;</p>
                              <p id=author-ahamada-farid-mpondo-black-andy-narjes-nalouti-tinhinene-mahtal-">author: &quot;AHAMADA Farid, MPONDO BLACK Andy, Narjes NALOUTI &amp; Tinhinene MAHTAL&quot;</p>
                              <ol>
                              <li>Présentation des données</li>
                              <li>Dashboard<ul>
                              <li>2.1 Carte</li>
                              <li>2.2 Localisation capteur sélectionné</li>
                              <li>2.3 Informations capteur sélectionné</li>
                              <li>2.4 Statistique descriptives (Plot)</li>
                              <li>2.5 Série temporelle</li>
                              </ul>
                              </li>
                              </ol>
                              <hr>
                              <h2 id="1-pr-sentation-des-donn-es">1. Présentation des données</h2>
                              <p>Sur le réseau parisien, la mesure du trafic s’effectue majoritairement par le biais de boucles électromagnétiques implantés dans la chaussée.
                              Deux types de données sont ainsi élaborés :
                               le taux d’occupation, qui correspond au temps de présence de véhicules sur la boucle en pourcentage d’un intervalle de temps fixe (une heure pour les données fournies). Ainsi, 25% de taux d’occupation sur une heure signifie que des véhicules ont été présents sur la boucle pendant 15 minutes. Le taux fournit une information sur la congestion routière. L’implantation des boucles est pensée de manière à pouvoir déduire, d’une mesure ponctuelle, l’état du trafic sur un arc.
                               le débit est le nombre de véhicules ayant passé le point de comptage pendant un intervalle de temps fixe (une heure pour les données fournies).
                              Ainsi, l’observation couplée en un point du taux d’occupation et du débit permet de caractériser le trafic. Cela constitue l’un des fondements de l’ingénierie du trafic, et l’on nomme d’ailleurs cela le « diagramme fondamental ».
                              Un débit peut correspondre à deux situations de trafic : fluide ou saturée, d’où la nécessité du taux d’occupation. A titre d’exemple : sur une heure, un débit de 100 véhicules par heure sur un axe habituellement très chargé peut se rencontrer de nuit (trafic fluide) ou bien en heure de pointe (trafic saturé).</p>
                              <hr>
                              <h2 id="2-dashboard">2. Dashboard</h2>
                              <p>Ce dashboard permet de visualiser les données des capteurs de trafic disponibles sur le site d&#39;OpenData de Paris.</p>
                              <p><strong>2.1 Carte</strong></p>
                              <p>Il est composé d&#39;une carte de capteurs sur laquelle l&#39;ensemble des capteurs sont représentés.</p>
                              <p><strong>2.2 Informations capteur sélectionné</strong></p>
                              <p>Il est possible de cliquer sur ces derniers afin d’obtenir plus de détails.
                              Ainsi, lors d’un clic sur un capteur, il sera possible d’obtenir l’adresse associée à celui-ci, mais également sa latitude et sa longitude.</p>
                              <p><strong>2.3 Statistique descriptives (Plot)</strong></p>
                              <p>En plus de cela, plusieurs graphiques s’afficheront.
                              Ceux-ci permettent de visualiser graphiquement les taux d’occupation récoltés par le capteur sélectionné : depuis le début, par année, par mois et enfin par jour.</p>
                              <p><strong>2.4 Série temporelle</strong></p>
                              <p>Pour finir, le dashboard permet également, lorsque les données le permettent, de réaliser des prédictions du taux et du débit en fonction des données récoltées précédemment.</p>
                              '))
  
  setupMap(input, output)
  
}