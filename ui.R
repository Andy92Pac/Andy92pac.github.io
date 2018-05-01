## ui.R ##

dashboardPage(
  dashboardHeader(title = "Dashboard trafic"),
  dashboardSidebar(
    sidebarMenu(
      menuItem(
        "Présentation", 
        tabName = "presentation", 
        icon = icon("home")
      ),
      menuItem(
        "Carte", 
        tabName = "maps", 
        icon = icon("globe")
      )
    )
  ),
  dashboardBody(
    useShinyalert(),
    
    tabItems(
      
      tabItem(
        tabName = "presentation",
        #includeMarkdown("README.md") 
        htmlOutput("pres")
      ),
      
      tabItem(
        tabName = "maps",
        
        fluidRow(
          
          #box(title = "Web Page Search", status = "primary",height = "155" 
           #   ,
            #  ),
          box(
            background = "black",
            title = "Carte des capteurs",
            width = 12,
            height = "100%",
            solidHeader = T,
            collapsible = TRUE,
            uiOutput("search_plot"),
            withSpinner(leafletOutput("map"))
          )
        ),
        
        fluidRow(

            box(
              background = "black",
              solidHeader = T,
              title = "Capteur",
              width = 5,
              collapsible = TRUE,
              withSpinner(leafletOutput("mapCapteur", height = "200px"))
            ),
            
            box(
              background = "black",
              solidHeader = T,
              title = "Informations",
              width = 7,
              collapsible = TRUE,
              textOutput("capId"),
              textOutput("capAdresse"),
              textOutput("capLat"),
              textOutput("capLng")
            ) 
            
          
        ),
        
        fluidRow(
          tabBox(
            title = "Analyse",
            height = "540px",
            id = "AnalyseTab", width = 12,
            tabPanel("Statistiques", 
                     tabBox(
                       title = "",
                       height = "400px",
                       width = 12,
                       id = "statBox",
                       tabPanel("Depuis le début",
                                withSpinner(plotOutput("plotFromStart"))
                       ),
                       tabPanel("Par année",
                                withSpinner(plotOutput("plotByYear"))
                       ),
                       tabPanel("Par mois",
                                withSpinner(plotOutput("plotByMonth"))
                       ),
                       tabPanel("Par jour",
                                withSpinner(plotOutput("plotByDay"))
                       )
                     )
                    ),
            tabPanel("Prédictif",
                     tabBox(
                       title = "",
                       height = "400px",
                       width = 12,
                       id = "statBox",
                       tabPanel("Débit/Jours",
                                withSpinner(plotOutput("predictDebitByDay"))
                       ),
                       tabPanel("Taux/Jours",
                                withSpinner(plotOutput("predictTxByDay"))
                       )
                     )
            )
          )
        )
      )
    )
  )
)