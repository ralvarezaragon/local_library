SELECT table_schema,
table_name,
CREATE_TIME,
UPDATE_TIME,
CHECK_TIME,
round(((data_length + index_length) / 1024 / 1024),2) 'Size in MB'
FROM information_schema.TABLES
WHERE TABLE_TYPE='BASE TABLE'
AND (
    date(create_time) between '2017-08-01' and '2017-09-20'
    OR date(update_time) between '2017-08-01' and '2017-09-20'
);


