#--- LIBRARIES ---#
library(ssh.utils)
library(dplyr)
library(tidyr)
#--- FUNCTIONS ---#
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

organize_data <- function(v_data, host, colname){
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
      host = host, 
      timestamp = format(Sys.time(), "%Y.%m.%d %H:%M")
    ) 
    
  df_data <- df_data[-1,]

  return (df_data)
}

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
#--- CODE ---#
#query <- "select id, command, info, db, time_ms, state from information_schema.processlist;"
query <- "show full processlist;"
command <- paste(
  "mysql -e '",
  query,
  "'",
  sep = ''
)
user <- "ralvarez"
l_host <- list(
  c("hopper1.basebone.com","hopper2.basebone.com","hopper3.basebone.com"),
  c("stats1.basebone.com","stats2.basebone.com","stats4.basebone.com"),
  c("frank1.basebone.com","frank2.basebone.com","frank3.basebone.com")
)
l_data <- sapply(l_host[[2]], function(x) get_ssh_result(user, x, command))

colname <- c("id", "user", "ip", "db", "command", "time_ms", "state", "info", "row_sent", "row_examined")

df_final <- data.frame(stringsAsFactors = F)

for (i in 1:3){
  df_temp <- organize_data(l_data[[i]], names(l_data[i]), colname) 
  df_final <- rbind(df_final, df_temp)
}
df_final <- select(df_final, id, user, db, command, time_ms, state, info, host, timestamp)
df_final$id <- as.numeric(df_final$id)
df_final$time_ms <- as.numeric(df_final$time_ms)
# Create an analysis summary for the runnign queries
df_summary <- get_summary(df_final)

# show list with friendly time format
df_final <- arrange(df_final, desc(time_ms)) %>%
  filter(command != 'Sleep') %>%
  mutate(time_min = round((time_ms/1000)/60, 2)) 
  

  



 


