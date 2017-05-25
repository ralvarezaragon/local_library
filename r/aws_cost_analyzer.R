# Get the files
#system("aws s3 sync s3://basebone.backups/cost_reports/costs_daily/ /tmp/aws_out")

setwd("/tmp/aws_out")

v_file <- list.files(
  path = ".",
  recursive = T,
  pattern = ".+csv.gz"
)


