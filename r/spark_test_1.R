library(SparkR, lib.loc="/opt/spark/R/lib")
library(dplyr)

Sys.setenv(SPARK_HOME="/opt/spark")
#Initalize  spark context
sc <- sparkR.session(
  appName = "spark_test_1"
)

s3_path <- "s3://basebone.backups/test_log/"
l_filename <- system(
  paste(
    "aws s3 ls",
    s3_path,
    "| awk {'print $4'}"
  ), 
  intern = TRUE
)
l_filename <- l_filename[-1]
#file_path <- '/home/ralvarez/Downloads/2.log'
file_path <- paste0('s3a://basebone.backups/test_log/', l_filename[2])
rdd <- read.df(source="text", path=file_path)