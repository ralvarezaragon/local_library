#!/usr/bin/env bash

threshold=60
token=xoxp-6464887266-108274455602-152033069333-f0e536696010a17ec88f4df94321b6bc

for node in {'10.0.3.21','10.0.3.50','10.0.3.40','10.0.3.30'};do
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
    } | awk '{ printf "%-10s %-15s %-20s %-10s %-5s\n", $1, $2, $3, $4 $5}') 2>&1 > /dev/null

    case ${node} in
        '10.0.3.21')
            node_name="hopper";;
        '10.0.3.50')
            node_name="stats";;
        '10.0.3.40')
            node_name="frank";;
        '10.0.3.20')
            node_name="fargo";;
    esac

    title="Incrementals above ${threshold}% fo limit in ${node_name}"
    escapedText=$(echo $output | sed 's/"/\"/g' | sed "s/'/\'/g" )

    curl -F content="${output}" \
        -F token=${token} \
        -F filetype=shell \
        -F channels=\#dba-utils \
        -F title="${title}" \
        https://slack.com/api/files.upload
done
