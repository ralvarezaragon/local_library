library(timevis)
#"2016-02-14 15:00:00"
data <- data.frame(
  id = 1:6,
  content = c(
    "hopper", 
    "stats",
    "frank",
    "hopper", 
    "stats",
    "frank"
  ),
  group = c(
    1,1,1,
    2,2,2
  ),
  start = c(
    "2017-01-01 02:00",
    "2017-01-01 05:00",
    "2017-01-01 0:00",
    "2017-01-01 0:00",
    "2017-01-01 0:00",
    "2017-01-01 08:30"
  ),
  end = c(
    "2017-01-01 03:50",
    "2017-01-01 07:30",
    "2017-01-01 01:50",
    "2017-01-01 08:00",
    "2017-01-01 01:00",
    "2017-01-01 15:30"
  ),
  style = c(
    "background-color: #A9F5A9;", 
    "background-color: #A9F5A9;",
    "background-color: #A9F5A9;", 
    "background-color: #819FF7;",
    "background-color: #819FF7;", 
    "background-color: #819FF7;"
  )
)


p <- timevis(
  data, 
  groups = data.frame(
    id = 1:2, 
    content = c("Backup2", "Backup1")
  )
)

print (p)
