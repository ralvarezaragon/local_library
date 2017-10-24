SELECT table_schema,
table_name,
CREATE_TIME,
UPDATE_TIME,
CHECK_TIME,
round(((data_length + index_length) / 1024 / 1024),2) 'Size in MB'
FROM information_schema.TABLES
WHERE TABLE_TYPE='BASE TABLE'
and (table_name = 'blocked_affiliate' or table_name = 'deviceatlas')

