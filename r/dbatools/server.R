source('functions.R')
l_host <- list(
  c("hopper1.basebone.com","hopper2.basebone.com","hopper3.basebone.com"),
  c("stats1.basebone.com","stats2.basebone.com","stats4.basebone.com"),
  c("frank1.basebone.com","frank2.basebone.com","frank3.basebone.com")
)

shinyServer(function(input, output, session) {
  ## running processes
  observeEvent(input$rp_run, {
    df_output <- run_rp(input$rp_cluster, l_host)
    df_summary <- get_summary(df_output)
    df_summary <- filter(df_summary, command == "Query")
    used_node1 <- as.numeric(ifelse(!is.na(df_summary[1,5]), df_summary[1,5], 0.00))
    used_node2 <- as.numeric(ifelse(!is.na(df_summary[2,5]), df_summary[2,5], 0.00))
    used_node3 <- as.numeric(ifelse(!is.na(df_summary[3,5]), df_summary[3,5], 0.00))
    used_node1 <- round(used_node1, 2)
    used_node2 <- round(used_node2, 2)
    used_node3 <- round(used_node3, 2)
    
    output$rp_table = renderDataTable({
      render_rp_table(input$rp_sleep, df_output)
    })
    
    output$rp_node1 <- renderInfoBox({
      render_rp_infobox(df_summary[1,1], used_node1)
    })
    
    output$rp_node2 <- renderInfoBox({
      render_rp_infobox(df_summary[2,1], used_node2)
    })
    
    output$rp_node3 <- renderInfoBox({
      render_rp_infobox(df_summary[3,1], used_node3)
    })
  })
  ## MySQL varaibles
  observeEvent(input$var_run, {
    df_var <- run_var(input$var_cluster, l_host)
    output$var_table = renderDataTable({
      df_var
    })
  })  
  ## Big tables
  observeEvent(input$bigt_run, {
    df_bigt <- run_bigt(input$bigt_cluster, input$bigt_size)
    df_by_schema <- summarize_by_schema(df_bigt)
    output$bigt_pie <- renderPlotly({
      plot_ly(
        df_by_schema, 
        x = ~table_schema, 
        y = ~total,
        text = ~total,
        color = ~table_schema,
        type = "bar"
        )
    })
    output$bigt_table = renderDataTable({
      df_bigt
    })
  })  
})
