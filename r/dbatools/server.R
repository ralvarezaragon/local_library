library(shiny)

source("server_rp_script.R")
shinyServer(function(input, output, session) {
  observeEvent(input$rp_run, {
    df_output <- run_rp(input$cluster)
    # prepare summary data for active connections
    df_summary <- get_summary(df_output)
    df_summary <- filter(df_summary, command == "Query")
    used_node1 <- as.numeric(ifelse(!is.na(df_summary[1,5]), df_summary[1,5], 0.00))
    used_node2 <- as.numeric(ifelse(!is.na(df_summary[2,5]), df_summary[2,5], 0.00))
    used_node3 <- as.numeric(ifelse(!is.na(df_summary[3,5]), df_summary[3,5], 0.00))
    used_node1 <- round(used_node1, 2)
    used_node2 <- round(used_node2, 2)
    used_node3 <- round(used_node3, 2)
    output$rp_title  <- renderText({
      paste("Running processes in", as.character(input$cluster))
    })
    output$rp_table = renderDataTable({
      if (input$rp_sleep == TRUE) {
        df_output <- filter(df_output, command != 'Sleep')
      }else{
        df_output
      }  
    })
    output$rp_node1 <- renderInfoBox({
      infoBox(
        "node 1", paste0(used_node1, "%"), icon = icon("dashboard"),
        color = "yellow"
      )
    })
    output$rp_node2 <- renderInfoBox({
      infoBox(
        "node 2", paste0(used_node2, "%"), icon = icon("dashboard"),
        color = "yellow"
      )
    })
    output$rp_node3 <- renderInfoBox({
      infoBox(
        "node 3", paste0(used_node3, "%"), icon = icon("dashboard"),
        color = "yellow"
      )
    })
  })
})
