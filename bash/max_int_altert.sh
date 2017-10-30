#!/usr/bin/env bash

threshold=60
declare -a node_list=("10.0.3.21" "10.0.3.51" "10.0.3.31" "10.0.3.41");

for node in "${node_list[@]}"; do
    output=$({
        echo "SELECT '${node}' as \`host\`,
        a.*,
        (round(((a.max_value - a.auto_increment) / a.max_value)-1, 2)*100)*-1 \`progress %\`
        from (
            SELECT
            is_t.table_schema,
            is_t.table_name,
            is_c.column_name,
            is_c.column_type,
            is_t.auto_increment,
            case
                when is_c.column_type like 'bigint(__) unsigned' then ~0
                when is_c.column_type like 'bigint(__)' then ~0 >> 1
                when is_c.column_type like 'int(%) unsigned' then ~0 >> 32
                when is_c.column_type like 'int(%)' then ~0 >> 33
                when is_c.column_type like 'mediumint(%) unsigned' then ~0 >> 40
                when is_c.column_type like 'mediumint(%)' then ~0 >> 41
                when is_c.column_type like 'smallint(_) unsigned' then ~0 >> 48
                when is_c.column_type like 'smallint(_)' then ~0 >> 49
                when is_c.column_type like 'tinyint(_) unsigned' then ~0 >> 56
                when is_c.column_type like 'tinyint(_)' then ~0 >> 57
                else 0
            end \`max_value\`
            FROM INFORMATION_SCHEMA.TABLES is_t
            INNER JOIN INFORMATION_SCHEMA.COLUMNS is_c ON is_t.table_name = is_c.table_name
            WHERE is_t.auto_increment is not null
            and is_c.column_key = 'PRI'
            and is_t.table_schema not like '%users%'
        ) a
        WHERE
        (round(((a.max_value - a.auto_increment) / a.max_value)-1, 2)*100)*-1 > ${threshold}" > /tmp/query.txt
        mysql -h ${node} < /tmp/query.txt
        rm /tmp/query.txt
    } | awk '{ printf "%-25s %-35s %-10s %-10s\n", $1, $2, $3, $4}') 
    #output=$({mysql -h $host -u ro -pinyourhonorbestofyou -e "$sql"} | awk '{ printf "%-25s %-35s %-10s %-10s\n", $1, $2, $3, $4}') 2>&1 > /dev/null
done


#| mail -s "[$hostname]Mysql slow queries" luchiana@basebone.com,juana@basebone.com,alex@basebone.com,rafael.alvarez@basebone.com
