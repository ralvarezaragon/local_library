## Libraries
library(shiny)
library(ssh.utils)
library(dplyr)
library(tidyr)
library(reshape)
library(plotly)
## Common functions
parse_cluster_no <- function(cl){
  switch(cl,
         "1"={"hopper"},
         "2"={"stats"},
         "3"={"frank"}
  )
}

get_ssh_result <- function(user, host, command){
  dest <- paste(
    user,
    "@",
    host,
    sep=''
  )
  l_result <- run.remote(
    cmd=command,
    remote=dest
  )
  
  return(l_result$cmd.out)
}

organize_data <- function(v_data, h, colname){
  df_data <- data.frame(
    raw=v_data,
    stringsAsFactors = F
  ) %>%
    separate(
      col = raw,
      into = colname,
      sep = "\t"
    ) %>%
    mutate(
      host = h
    ) 
  
  df_data <- df_data[-1,]
  
  return (df_data)
}
## running processes
get_summary <- function(df_data){
  # some analisys
  subtotals <- df_data %>% 
    group_by(host, command) %>% 
    count()
  totals <- df_data %>% 
    group_by(host) %>% 
    count()
  df_summary = inner_join(subtotals, totals, by = "host") %>%
    mutate(perc = round((n.x/n.y)*100, 2))
  
  return (df_summary)
}

run_rp <- function(cluster_no, l_host){
  cluster_no <- as.integer(cluster_no)
  query <- "show full processlist;"
  command <- paste(
    "mysql -e '",
    query,
    "'",
    sep = ''
  )
  user <- "ralvarez"
  
  l_data <- lapply(l_host[[cluster_no]], function(x) get_ssh_result(user, x, command))
  
  colname <- c("id", "user", "ip", "db", "command", "time_ms", "state", "info", "row_sent", "row_examined")
  
  df_final <- data.frame(stringsAsFactors = F)
  
  for (i in 1:3){
    df_temp <- organize_data(l_data[[i]], l_host[[cluster_no]][i], colname) 
    df_final <- rbind(df_final, df_temp)
  }
  df_final <- select(df_final, id, user, db, command, time_ms, state, host, info)
  df_final$id <- as.numeric(df_final$id)
  df_final$time_ms <- as.numeric(df_final$time_ms)
  
  df_final <- arrange(df_final, desc(time_ms)) %>%
    mutate(time_min = round((time_ms/1000)/60, 2)) %>%
    filter(info != "show full processlist")
  
  return (df_final)
}

render_rp_table <- function(sleep_option, df){
  if (sleep_option == TRUE) {
    df <- filter(df, command != 'Sleep')
  }
  
  return (df)
}

render_rp_infobox <- function(title, value){
  infoBox(
    title, paste0(value, "%"), icon = icon("dashboard"),
    color = "yellow"
  )
} 
## Mysql variables
run_var <- function(cluster_no, l_host){
  cluster_no <- as.integer(cluster_no)
  query <- "show variables;"
  command <- paste(
    "mysql -e '",
    query,
    "'",
    sep = ''
  )
  user <- "ralvarez"
  l_data <- lapply(l_host[[cluster_no]], function(x) get_ssh_result(user, x, command))
  colname <- c("variable", "value")
  df_final <- data.frame(stringsAsFactors = F)
  
  for (i in 1:3){
    df_temp <- organize_data(l_data[[i]], l_host[[cluster_no]][i], colname) 
    df_final <- rbind(df_final, df_temp)
  }
  df_final <- cast(df_final, variable ~ host)
  return (df_final)
}

## big tables
summarize_by_schema <- function(df_data){
  # some analisys
  df_total <- df_data %>%
    group_by(table_schema) %>%
    summarise(total = sum(as.numeric(size_mb))) %>%
    arrange(desc(total))
  return (df_total)
}

run_bigt <- function(cluster_no,  tsize){
  cluster_no <- as.integer(cluster_no)
  query <- paste0("SELECT table_schema
    ,table_name
    ,table_rows
    ,create_time
    ,round(((data_length + index_length) / 1024 / 1024),2) 
    FROM information_schema.TABLES
    WHERE ((data_length + index_length) / 1024 / 1024) >= ",tsize,"
    ORDER BY table_schema, table_name;"
  )
  command <- paste0(
    "mysql -e '",
    query,
    "'"
  )
  user <- "ralvarez"
  node_name <- parse_cluster_no(cluster_no)
  node_name <- paste0(node_name, "1.basebone.com")
  l_data <- get_ssh_result(user, node_name, command)
  colname <- c("table_schema", "table_name", "table_rows", "creation_date", "size_mb")
  df_final <- data.frame(stringsAsFactors = F)
  df_final <- organize_data(l_data, node_name, colname)  
  df_final$size_mb <- as.numeric(df_final$size_mb)
  return (df_final)
}
