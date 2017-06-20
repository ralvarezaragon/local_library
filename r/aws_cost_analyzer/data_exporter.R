library(data.table)
library(plyr)
library(dplyr)

create_dataset <- function(f){
  if(!exists("df_final")){
    df_final <- data.frame(stringsAsFactors = F)
  }
  df_temp <- fread(f, header = T, sep = ',')
  df_final <- rbind(df_final, df_temp)
  return(df_final)
}

download_from_s3 <- function(f){
  system(paste0("aws s3 sync s3://basebone.backups/cost_reports/daily_summary/ ", f))
  system(paste0("rm -r ",f, "/*/*/*.json"))
}

extract_csv_data <- function(f){
  v <- list.files(
    path = f,
    recursive = T,
    pattern = ".+csv.gz",
    full.names = T
  )
  sapply(v, function(x) system(paste0("gunzip ",x)))
  v <- list.files(
    path = f,
    recursive = T,
    pattern = ".+csv",
    full.names = T
  )
  return (v)
}

modify_result <- function(df){
  v_to_keep <- c(
    "identity_lineitemid",
    "lineitem_lineitemtype",
    "lineitem_usagestartdate",
    "lineitem_usageenddate",
    "lineitem_productcode",
    "lineitem_usagetype",
    "lineitem_usageamount",
    "lineitem_currencycode",
    "lineitem_unblendedrate",
    "lineitem_unblendedcost",
    "lineitem_lineitemdescription",
    "product_instancetype",
    "resourcetags_user_area",
    "resourcetags_user_db",
    "resourcetags_user_dtap",
    "resourcetags_user_purpose"
  )
  df <- df %>% select_(
    .dots = v_to_keep
  ) %>% 
    distinct(identity_lineitemid, lineitem_usagestartdate, .keep_all = TRUE) %>%
    select(-identity_lineitemid) 
  return (df)
}

fix_datatypes <- function(df){
  df$lineitem_usagestartdate <- as.POSIXct(df$lineitem_usagestartdate, format="%Y-%m-%dT%H:%M:%S")
  df$lineitem_usageenddate <- as.POSIXct(df$lineitem_usageenddate, format="%Y-%m-%dT%H:%M:%S")
  df$lineitem_usageamount <- round(df$lineitem_usageamount,6)
  df$lineitem_unblendedrate <- round(df$lineitem_unblendedrate,6)
  df$lineitem_unblendedcost <- round(df$lineitem_unblendedcost,6)
  return (df)
}

main <- function(){
  aws_folder <- "/tmp/aws_out/"
  # Download the files and remove the json files
  download_from_s3(aws_folder)
  # Extract teh gz files and create a vector with csv files path
  v_file <- extract_csv_data(aws_folder)
  # Create the df using each file
  df_result <- ldply(v_file, .fun = function(x)create_dataset(x))
  # Reformat col names
  names(df_result) <- gsub("/", "_", tolower(names(df_result)))
  names(df_result) <- gsub(":", "_", tolower(names(df_result)))
  # Drop unnecesary cols, remove duplicates & remove itemId after uniqueness checking
  df_result <- modify_result(df_result)
  # Datatypes
  df_result <- fix_datatypes(df_result)
  return (df_result)
}



