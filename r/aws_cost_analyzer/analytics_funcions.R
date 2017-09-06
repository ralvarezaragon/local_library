daily_total <- function(df_in){
  df <- df_in %>% 
    select(lineitem_usagestartdate, lineitem_unblendedcost) %>%
    group_by(as.Date(lineitem_usagestartdate)) %>%
    summarise(total = round(sum(lineitem_unblendedcost), 2))
  names(df) <- c("date", "total")
  return (df)
}

total_this_month <- function(df_in){
  df <- df_in %>% 
    filter(
      format(lineitem_usagestartdate, "%m") == format(Sys.Date(), "%m") & 
      format(lineitem_usagestartdate, "%Y") == format(Sys.Date(), "%Y")
    ) %>%
    select(lineitem_unblendedcost) %>%
    summarise(total = round(sum(lineitem_unblendedcost), 2))
  names(df) <- c("total")
  return (df)
}

prod_this_month <- function(df_in){
  df <- df_in %>% 
    filter(
      format(lineitem_usagestartdate, "%m") == format(Sys.Date(), "%m") & 
        format(lineitem_usagestartdate, "%Y") == format(Sys.Date(), "%Y")
    ) %>%
    select(lineitem_productcode, lineitem_unblendedcost) %>%
    mutate(lineitem_productcode = replace(lineitem_productcode, lineitem_productcode=="", "Unknown")) %>%
    group_by(lineitem_productcode) %>%
    summarise(total = round(sum(lineitem_unblendedcost), 2)) %>%
    arrange(desc(total))
  names(df) <- c("product", "total")
  df <- head(df, 1)
  return (df)
}

country_total <- function(df_in){
  df <- df_in %>% 
    select(resourcetags_user_area, lineitem_unblendedcost) %>%
    mutate(resourcetags_user_area = replace(resourcetags_user_area, resourcetags_user_area=="", "Unknown")) %>%
    group_by(resourcetags_user_area) %>%
    summarise(total = round(sum(lineitem_unblendedcost), 2)) 
  names(df) <- c("country", "total")
  return (df)
}

country_monthly_total <- function(df_in){
  df <- df_in %>% 
    select(resourcetags_user_area, lineitem_usagestartdate, lineitem_unblendedcost) %>%
    mutate(resourcetags_user_area = replace(resourcetags_user_area, resourcetags_user_area=="", "Unknown")) %>%
    group_by(resourcetags_user_area, format(lineitem_usagestartdate, "%b")) %>%
    summarise(total = round(sum(lineitem_unblendedcost), 2))
  names(df) <- c("country", "month", "total")
  return (df)
}

product_daily_total <- function(df_in){
  df <- df_in %>% 
    select(lineitem_productcode, lineitem_usagestartdate, lineitem_unblendedcost) %>%
    mutate(lineitem_productcode = replace(lineitem_productcode, lineitem_productcode=="", "Unknown")) %>%
    group_by(lineitem_productcode, as.Date(lineitem_usagestartdate)) %>%
    summarise(total = round(sum(lineitem_unblendedcost), 2))
  names(df) <- c("product", "date", "total")
  return (df)
}

country_daily_total <- function(df_in){
  df <- df_in %>% 
    select(resourcetags_user_area, lineitem_usagestartdate, lineitem_unblendedcost) %>%
    mutate(resourcetags_user_area = replace(resourcetags_user_area, resourcetags_user_area=="", "Unknown")) %>%
    group_by(resourcetags_user_area, as.Date(lineitem_usagestartdate)) %>%
    summarise(total = round(sum(lineitem_unblendedcost), 2))
  names(df) <- c("country", "date", "total")
  return (df)
}

purpose_daily_total <- function(df_in){
  df <- df_in %>% 
    select(resourcetags_user_purpose, lineitem_usagestartdate, lineitem_unblendedcost) %>%
    mutate(resourcetags_user_purpose = replace(resourcetags_user_purpose, resourcetags_user_purpose=="", "Unknown")) %>%
    group_by(resourcetags_user_purpose, as.Date(lineitem_usagestartdate)) %>%
    summarise(total = round(sum(lineitem_unblendedcost), 2))
  names(df) <- c("purpose", "date", "total")
  return (df)
}

dtap_daily_total <- function(df_in){
  df <- df_in %>% 
    select(resourcetags_user_dtap, lineitem_usagestartdate, lineitem_unblendedcost) %>%
    mutate(resourcetags_user_dtap = replace(resourcetags_user_dtap, resourcetags_user_dtap=="", "Unknown")) %>%
    group_by(resourcetags_user_dtap, as.Date(lineitem_usagestartdate)) %>%
    summarise(total = round(sum(lineitem_unblendedcost), 2))
  names(df) <- c("dtap", "date", "total")
  return (df)
}

