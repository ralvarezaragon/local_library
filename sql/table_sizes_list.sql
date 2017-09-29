SELECT table_schema,
table_name,
round(((data_length + index_length) / 1024 / 1024),2) 'Size in MB'
FROM information_schema.TABLES
WHERE TABLE_TYPE='BASE TABLE'
AND table_schema = 'esme_hasoffers';

