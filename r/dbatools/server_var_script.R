#--- LIBRARIES ---#
library(ssh.utils)
library(dplyr)
library(tidyr)

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
      host = host
    ) 
  
  df_data <- df_data[-1,]
  
  return (df_data)
}

run_var <- function(cluster_no){
  cluster_no <- as.integer(cluster_no)
  query <- "show global variables;"
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
  
  l_data_var <- lapply(l_host[[cluster_no]], function(x) get_ssh_result(user, x, command))
  colname <- c("variable", "value")
  df_final <- data.frame(stringsAsFactors = F)
  
  for (i in 1:3){
    df_temp <- organize_data(l_data_var[[i]], l_host[[cluster_no]][i], colname) 
    df_final <- rbind(df_final, df_temp)
  }
  return (df_final)
}