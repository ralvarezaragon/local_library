SELECT table_schema as `dbname`, 
table_name AS `table`,
round(((data_length + index_length) / 1024 / 1024), 2) `Size in MB`
FROM information_schema.TABLES
WHERE TABLE_TYPE='BASE TABLE'
and  table_schema='esme_numbers';



-- Old tables outside admin dbs
SELECT table_schema,
count(table_name) as `table_count`
FROM information_schema.TABLES
WHERE TABLE_TYPE='BASE TABLE'
and table_name like '%old'
and table_schema not in ('admin_trash', 'admin_archive')
GROUP BY table_schema;

SELECT concat(table_schema,'.', table_name) 'full_table_name' FROM information_schema.TABLES WHERE TABLE_TYPE='BASE TABLE' and  table_schema not in ('admin_trash', 'admin_archive')

-- Empty DBs list
select s.schema_name,
count(t.table_name) as `table_count`
FROM information_schema.SCHEMATA s
LEFT JOIN information_schema.TABLES t ON t.table_schema = s.schema_name
WHERE s.schema_name not in ('admin_resources', 'admin_trash', 'admin_archive', 'connections')
GROUP BY s.schema_name
HAVING count(t.table_name) = 0



SELECT @@hostname,
(
    select count(s.schema_name)
    FROM information_schema.SCHEMATA s
    LEFT JOIN information_schema.TABLES t
        ON t.table_schema = s.schema_name
    WHERE t.table_schema is null
    AND s.schema_name not in ('admin_resources', 'admin_trash', 'admin_archive', 'connections')
) as `Empty DBs`,
coalesce((
    SELECT count(table_name)
    FROM information_schema.TABLES
    WHERE TABLE_TYPE='BASE TABLE'
    and table_name like '%old'
    and table_schema not in ('admin_trash', 'admin_archive')
    GROUP BY table_schema),0
) as `Old tables`,
coalesce((
    SELECT count(table_name)
    FROM information_schema.TABLES
    WHERE TABLE_TYPE='BASE TABLE'
    and table_schema = 'admin_trash'
    GROUP BY table_schema),0
) as `Tables in trash`,
coalesce((
    SELECT sum(round(((data_length + index_length) / 1024 / 1024),2))
    FROM information_schema.TABLES
    WHERE TABLE_TYPE='BASE TABLE'
    and table_schema = 'admin_trash'
    GROUP BY table_schema),0
) as `Trash size`,
coalesce((
    SELECT count(table_name)
    FROM information_schema.TABLES
    WHERE TABLE_TYPE='BASE TABLE'
    and table_schema = 'admin_archive'
    GROUP BY table_schema),0
) as `Tables in archive`,
coalesce((
    SELECT sum(round(((data_length + index_length) / 1024 / 1024),2))
    FROM information_schema.TABLES
    WHERE TABLE_TYPE='BASE TABLE'
    and table_schema = 'admin_archive'
    GROUP BY table_schema),0
) as `Archive size`,
