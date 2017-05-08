sidebarMenu(
  menuItem(
    "Running processes", 
    tabName = "running_processes", 
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
    checkboxInput("rp_sleep", label = "Include sleep connections", value = FALSE)
  ),
  menuItem("Widgets", tabName = "widgets", icon = icon("th"))
)