library(shiny)
library(shinydashboard)

dashboardPage(
  dashboardHeader(
    title = "DBA tools"
  ),
  dashboardSidebar(
    source("ui_sidebar.R")
  ),
  dashboardBody(
    h3(textOutput("rp_title")),
    infoBoxOutput("rp_node1"),
    infoBoxOutput("rp_node2"),
    infoBoxOutput("rp_node3"),
    dataTableOutput("rp_table")
  )
)