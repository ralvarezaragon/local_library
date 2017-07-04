SELECT table_schema
  ,table_name
  ,table_rows
  ,create_time
  ,round(((data_length + index_length) / 1024 / 1024),2) 'Size in MB'
FROM information_schema.TABLES
WHERE TABLE_TYPE='BASE TABLE' 
GROUP BY table_schema, table_name
having sum(round(((data_length + index_length) / 1024 / 1024),2)) > 1024
order by 5 desc;