## ui.R ##

dashboardPage(
  dashboardHeader(title = "Dashboard trafic"),
  dashboardSidebar(
    sidebarMenu(
      menuItem(
        "Carte", 
        tabName = "maps", 
        icon = icon("globe")
      ),
      menuItem(
        "Analyse", 
        tabName = "analyse", 
        icon = icon("bar-chart"),
        menuSubItem("Watersheds", tabName = "c_water", icon = icon("area-chart")),
        menuSubItem("Population", tabName = "c_pop", icon = icon("area-chart"))
      )
    )
  ),
  dashboardBody(
    
    tabItems(
      
      tabItem(
        tabName = "maps",
        
        fluidRow(
          
          #box(title = "Web Page Search", status = "primary",height = "155" 
           #   ,
            #  ),
          box(
            title = "Carte des capteurs",
            width = 12,
            height = "100%",
            solidHeader = T,
            collapsible = TRUE,
            uiOutput("search_plot"),
            leafletOutput("map")
          )
        ),
        
        fluidRow(

            box(
              title = "Capteur",
              width = 5,
              collapsible = TRUE,
              leafletOutput("mapCapteur", height = "200px")
            ),
            
            box(
              title = "Informations",
              width = 7,
              collapsible = TRUE,
              textOutput("capId"),
              textOutput("capLat"),
              textOutput("capLng")
            ) 
            
          
        )
        
      ),
      tabItem(
        tabName = "m_pop",
        # Map in Dashboard
        leafletOutput("l_population")
      ),
      tabItem(
        tabName = "charts",
        h2("Second tab content")
      )
    )
  )
)
