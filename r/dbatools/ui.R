library(shiny)
library(shinydashboard)
library(plotly)

header <- dashboardHeader(
  title = "DBA tools"
)

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem(
      "Running processes", 
      tabName = "rp", 
      icon = icon("dashboard")
    ),  
    menuItem(
      "Mysql variables", 
      tabName = "var", 
      icon = icon("dollar")
    ),
    menuItem(
      "Big tables", 
      tabName = "bigt", 
      icon = icon("table")
    )
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(
      tabName = "rp",
      fluidRow(
        box(
          width = 3,
          selectInput("rp_cluster", "Cluster name", choices = c('hopper'=1, 'stats'=2, 'frank'=3)),
          actionButton("rp_run", "Run"),
          checkboxInput("rp_sleep", label = "Exclude sleep connections", value = TRUE)
        ),
        box(
          width = 9,
          infoBoxOutput("rp_node1"),
          infoBoxOutput("rp_node2"),
          infoBoxOutput("rp_node3")
        )
      ),
      fluidRow(
        dataTableOutput("rp_table")
      )
    ),
    tabItem(
      tabName = "var",
      fluidRow(
        box(
          width = 3,
          selectInput("var_cluster", "Cluster name", choices = c('hopper'=1, 'stats'=2, 'frank'=3)),
          actionButton("var_run", "Run")
        )
      ),
      fluidRow(
        dataTableOutput("var_table")
      )
    )
    ,
    tabItem(
      tabName = "bigt",
      fluidRow(
        box(
          width = 3,
          selectInput("bigt_cluster", "Cluster name", choices = c('hopper'=1, 'stats'=2, 'frank'=3)),
          sliderInput("bigt_size", "Minimum size (Mb)", min=0, max=5000, value=1000, step= 50),
          actionButton("bigt_run", "Run")
        ),
        box(
          width = 9,
          plotlyOutput("bigt_pie")
        )
      ),
      fluidRow(
        dataTableOutput("bigt_table")
      )
    )
  )
)

dashboardPage(
  header,
  sidebar,
  body
)