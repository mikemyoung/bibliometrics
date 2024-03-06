

  
theHeader <- dashboardHeader(titleWidth = 250)
  anchor <- tags$a(href='https://www.antarcticanz.govt.nz/',
                   tags$img(src='antnzlogo.png', height = '80px',
                            style = "padding-top: 10px; padding-bottom: 10px; padding-left: 10px; padding-right: 10px; margin: auto; display: block;"))
  
  theHeader$children[[2]]$children <- tags$div(
    tags$head(tags$style(HTML(".name { background-color: #367FA9 }"))),
    anchor,
    class = 'name')


theSidebar <- dashboardSidebar(
    width = 250,
    sidebarMenu(
      menuItem("Home", tabName = "home"),
      menuItem("Data", tabName = "data"),
      menuItem(
        "Download Publications",
        tabName = "publications",
        div(
          downloadLink("downloadAntnzAck", HTML(paste(icon("download"), " Antarctica NZ Acknowledged"))),
          style = "display: block; margin-left: 20px; margin-bottom: 10px;"  # Adjust margin as needed
        ),
        div(
          downloadLink("downloadAntnzSupport", HTML(paste(icon("download"), " Antarctica NZ Supported"))),
          style = "display: block; margin-left: 20px; margin-bottom: 10px;"  # Adjust margin as needed
        ),
        div(
          downloadLink("downloadAsp", HTML(paste(icon("download"), " Antarctic Science Platform"))),
          style = "display: block; margin-left: 20px; margin-bottom: 10px;"  # Adjust margin as needed
        ),
        div(
          downloadLink("downloadTotalAntnz", HTML(paste(icon("download"), " Total Antarctica NZ"))),
          style = "display: block; margin-left: 20px; margin-bottom: 10px;"  # Adjust margin as needed
        ),
        div(
          downloadLink("downloadAntSci", HTML(paste(icon("download"), " NZ Antarctic & Southern Ocean"))),
          style = "display: block; margin-left: 20px; margin-bottom: 10px;"  # Adjust margin as needed
        )
      ),
      menuItem("Submit Publication", tabName = "submit")
      
    )
  )
  
theBody <- dashboardBody(
   tags$head(tags$style(HTML('.content-wrapper { overflow: auto; }'))),
    tabItems(
      tabItem(tabName = "data",
              box(width = 12, height = 600, status = "primary", solidHeader = TRUE, title = HTML('<div style="color: white; text-align: center; text-transform: none; font-family: sans-serif;"><span style="font-style: normal;">Publications</span></div>'),
                  br(),
                  div(withSpinner(plotlyOutput("totalsPlot"), type = 1), align = "center")),
              
              box(width = 12, height = 600, status = "primary", solidHeader = TRUE, title = HTML('<div style="color: white; text-align: center; text-transform: none; font-family: sans-serif;"><span style="font-style: normal;">Citations</span></div>'),
                  br(),
                  div(withSpinner(plotlyOutput("citationPlot"), type = 1), align = "center")),
              
              box(width = 12, height = 600, status = "primary", solidHeader = TRUE, title = HTML('<div style="color: white; text-align: center; text-transform: none; font-family: sans-serif;"><span style="font-style: normal;">Percentiles</span></div>'),
                  br(),
                  div(withSpinner(plotlyOutput("percentilePlot"), type = 1), align = "center")
              )
      ),
      tabItem(
        tabName = "submit",
        fluidPage(
          fluidRow(
            column(
              width = 12,  # Adjust the width as needed
              surveyOutput(
                survey_questions,
                survey_title = "Submit a Publication",
                theme = "#3c8dbc"
              )
            )
          )
        )
      ),
      
      tabItem(
        tabName = "home",
        fluidRow(
          column(
            width = 12,
            style = "overflow: hidden; position: relative;",
            tags$img(
              src = 'runway_homepage.jpg',
              width = '100%',
              height = 'auto',
              #style = "position: absolute; top: -15%; transform: translateY(-46%); margin-left: 0;"  # Adjust the margin-right value
            )
          )
        ),
        h4("Bibliometrics", style = "font-size: 48px; margin-bottom: 35px; margin-top: 20px;"),
        h4("About", style = "font-size: 32px; margin-left: 5px; margin-bottom: 15px; margin-top: 0px"),
        p(HTML("Antarctica New Zealand is the government agency responsible for carrying out New Zealand's activities in Antarctica, supporting world-leading science and environmental protection. Our vision is: Antarctica and the Southern Ocean – valued, protected, understood. Antarctica New Zealand aims to achieve <em>'Enhanced scientific research in Antarctica and the Southern Ocean'</em>. To achieve this aim, Antarctica New Zealand will support world-class research in Antarctica and:"),
          style = "font-size: 16px; margin-left: 6px; margin-left: 5px; margin-bottom: 5px; margin-top: 5px;"),
        p(HTML('<em>"Monitor and quantity and quality of outputs and outcomes from the programmes we support"</em>'),
          style = "font-size: 16px;text-align: center; margin-bottom: 15px; margin-top: 15px;"),
        p("The Antarctica New Zealand Bibliography (2010-2022) includes over 800 peer-reviewed scientific publications that have been produced with Antarctica New Zeland's support, and provides one measure of scientific output when assessing world class research.",
          style = "font-size: 16px; margin-left: 7px; margin-left: 5px; margin-bottom: 35px; margin-top: 5px;"),
        h4("Method", style = "font-size: 32px; margin-left: 6px; margin-left: 5px; margin-bottom: 15px; margin-top: 0px;"),
        p("The Antarctica New Zealand Bibliography is aggregated from",
  a(href = "https://scopus.com/", target = "_blank", "Scopus"),
  ". Search terms are used to retrieve publications that acknowledge Antarctica New Zealand's support, or have been generated with Antarctica New Zealand's support.",
  style = "font-size: 16px; margin-left: 7px; margin-bottom: 0.2em; margin-top: 0px;"),

        p("Further information can be found at ", a(href = "https://doi.org/", target = "_blank", "https://doi.org/") ,
          style = "font-size: 16px; margin-left: 7px; margin-left: 5px; margin-bottom: 35px; margin-top: 0px"),
        h4("Definitions", style = "font-size: 32px; margin-left: 6px; margin-bottom: 15px; margin-top: 0px"),
        fluidRow(
          column(
            dataTableOutput("table"),
            width = 10,
            style = "margin-left: 6px;"
          )
        ),
        tags$br()
      )
    ),
    tags$head(
      tags$link(rel = "icon", type = "image/png", href = "antnz_favicon.png"),
      tags$style(HTML("
      .content-wrapper { overflow: auto; }
      .main-header .title { visibility: hidden; }
      .main-header {height: 80px !important;}
      .main-header .logo {height: 80px !important;}
      .main-header .navbar {height: 80px !important;}
      .sidebar {padding-top: 40px !important;}
    "))
    )
  )
#)
  
ui <- dashboardPage(title = "Antarctica New Zealand", theHeader, theSidebar, theBody)