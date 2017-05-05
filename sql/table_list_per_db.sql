SELECT table_schema
  ,table_name
  #,count(table_name) as 'Tables count'
  ,create_time
  ,sum(round(((data_length + index_length) / 1024 / 1024),2)) 'Size in MB'
FROM information_schema.TABLES
WHERE TABLE_TYPE='BASE TABLE'
and table_schema = 'esme_identification'
GROUP BY table_schema, table_name
#having sum(round(((data_length + index_length) / 1024 / 1024),2)) > 50
order by create_time;