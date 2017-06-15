library(shiny)
library(plotly)

source('data_exporter.R')
source('analytics_funcions.R')

shinyServer(function(input, output) {
  df_result <- main()
  df_purpose_daily <- purpose_daily_total(df_result)
  df_country_monthly <- country_total(df_result)
  df_total_this_month <- total_this_month(df_result)
  df_prod_this_month <- prod_this_month(df_result)
  
  # output$cost_daily <- renderPlotly({
  #   plot_ly(
  #     df_purpose_daily, 
  #     x = ~date, 
  #     y = ~total,
  #     text = ~total,
  #     color = ~purpose,
  #     type = "bar"
  #   )
  # })
  
  output$cost_daily <- renderPlotly({
    plot_ly(source = "source") %>%
      add_lines(
        data = df_purpose_daily, 
        x = ~date, 
        y = ~total, 
        color = ~total, 
        mode = "lines", 
        line = list(width = 3)
      )
  })

  output$cost_monthly <- renderPlotly({
    plot_ly(
      df_country_monthly, 
      x = ~country, 
      y = ~total,
      text = ~total,
      color = ~country,
      type = "bar"
    )
  })
  
  output$total_this_month <- renderInfoBox({
    infoBox(
      "This month", 
      paste0( "$ ", df_total_this_month[1,1]), 
      icon = icon("thumbs-up", lib = "glyphicon"),
      color = "green",
      fill = TRUE
    )
  })
  
  output$prod_this_month <- renderInfoBox({
    infoBox(
      df_prod_this_month[,1], 
      paste0( "$ ", df_prod_this_month[,2]), 
      icon = icon("thumbs-up", lib = "glyphicon"),
      color = "green",
      fill = TRUE
    )
  })
  
})