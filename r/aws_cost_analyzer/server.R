open_csv <- function(){
  df <- fread('/home/ralvarez/Repos/local_library/python/aws_cost_etl/aws_costs_2017-09-20.csv', header = T, sep = ';')
  v_to_keep <- c(
    "lineitem_usagestartdate",
    "lineitem_unblendedcost",
    "resourcetags_user_area",
    "resourcetags_user_dtap",
    "resourcetags_user_purpose",
    "lineitem_productcode"
  )
  # Reformat col names
  names(df) <- gsub("/", "_", tolower(names(df)))
  names(df) <- gsub(":", "_", tolower(names(df)))
  df$lineitem_usagestartdate <- as.POSIXct(df$lineitem_usagestartdate, format="%Y-%m-%dT%H:%M:%S")
  df$lineitem_usagestartdate <- as.Date(df$lineitem_usagestartdate)
  df$lineitem_unblendedcost <- round(df$lineitem_unblendedcost,6)
  df <- df %>% select_(
    .dots = v_to_keep
  )
  return (df)
}

raw_df <- open_csv()

date_total <- function(df_in, criteria, attr_color){
  v_to_keep <- c(
    "lineitem_usagestartdate",
    "lineitem_unblendedcost",
    attr_color
  )
  df <- df_in %>% 
    select_(.dots = v_to_keep)
  if (criteria == 'monthly'){
    v_to_group <- c(
      'format(lineitem_usagestartdate, "%Y-%m-01")', 
      attr_color
    )
  } else {
    v_to_group <- c(
      'format(lineitem_usagestartdate, "%Y-%m-%d")', 
      attr_color
    )
  }
  df <- group_by_(df, .dots = v_to_group) %>%
    summarise(total = round(sum(lineitem_unblendedcost), 2))
  names(df) <- c("date", "attr_color", "total")
  return (df)
}


shinyServer(function(input, output, session) {
  new_df <- reactive({
    d <- date_total(raw_df, input$date_filter, input$color_sel)
  })
  
  output$t_result <- renderTable(new_df())
  
  output$multiplot<-renderPlot({
    ggplot(
      new_df(),
      aes(
        x = as.Date(date), 
        y = total, 
        col = attr_color
      )
    ) + 
    geom_line(
      size = 2
    ) 
  })
})



















