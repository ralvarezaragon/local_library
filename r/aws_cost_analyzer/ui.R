library(shiny)
library(shinydashboard)

header <- dashboardHeader(
  title = "AWS cost analyzer"
)

sidebar <- dashboardSidebar(
  disable = TRUE
)

body <- dashboardBody(
  fluidRow(
    box(
      width = 12,
      status = "primary", 
      solidHeader = F,
      collapsible = F,
      infoBoxOutput("total_this_month"),
      infoBoxOutput("prod_this_month")
    ),
    box(
      width = 3,
      title = "Monthly costs per country",
      status = "primary", 
      solidHeader = TRUE,
      collapsible = TRUE,
      plotlyOutput("cost_monthly")
    ),
    box(
    width = 9,
    status = "primary", 
    solidHeader = TRUE,
    collapsible = TRUE,
    title = "Daily costs",
    plotlyOutput("cost_daily")
    )
  )
)

dashboardPage(
  header,
  sidebar,
  body
)
