dashboardSidebar(
  sidebarMenu(
    menuItem(
      "Running processes", 
      tabName = "rp", 
      icon = icon("dashboard"),
      div(
        style="display:inline-block; width: 70%", 
        selectInput("cluster", "Cluster name", choices = c('hopper'=1, 'stats'=2, 'frank'=3))
      ),
      div(
        style="display:inline-block", 
        actionButton("rp_run", "Run"), 
        width=1
      ),
      checkboxInput("rp_sleep", label = "Exclude sleep connections", value = TRUE)
    ),
    menuItem(
      "Mysql variables", 
      tabName = "var", 
      icon = icon("dollar")
    )
  )
)