#install.packages("devtools")
#devtools::install_github("rstudio/sparklyr")
library(SparkR, lib.loc="/opt/spark/R/lib")
library(sparklyr)
library(dplyr)
library(data.table)

Sys.setenv(SPARK_HOME="/opt/spark")

sc <- spark_connect(
  master = "local",
  appName = "spark_test"
)

# Get file names from bucket
s3_path <- "s3://basebone.backups/test_log/"
l_filename <- system(
  paste(
    "aws s3 ls",
    s3_path,
    "| awk {'print $4'}"
  ), 
  intern = TRUE
)
# For testing purposes
l_filename <- l_filename[-1]

file_path <- paste0('s3a://basebone.backups/test_log/', l_filename[2])
rdd <- read.df(file_path, "text") 
