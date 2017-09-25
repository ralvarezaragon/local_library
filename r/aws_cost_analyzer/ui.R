library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(data.table)

header <- dashboardHeader(
  title = "AWS cost analyzer"
)

sidebar <- dashboardSidebar(
  disable = TRUE
)

body <- dashboardBody(
  fluidRow(
    box(
      width = 10,
      status = "primary", 
      solidHeader = F,
      collapsible = F,
      plotOutput("multiplot")
    ),
    
    box(
      width = 2,
      status = "primary", 
      solidHeader = F,
      collapsible = F,
      selectInput(
        "date_filter", 
        "Date range",
        c(
          "Monthly" = "monthly",
          "Daily" = "daily"
        )
      ),
      selectInput(
        "color_sel", 
        "Breakdown options",
        c(
          "None" = "1",
          "By country" = "resourcetags_user_area",
          "By environment" = "resourcetags_user_dtap",
          "By service" = "lineitem_productcode"
        )
      ),
      tableOutput('t_result')
    )
  )
)

dashboardPage(
  header,
  sidebar,
  body
)
