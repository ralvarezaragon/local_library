#!/bin/bash

server="system.basebone.com";
user="ralvarez";
ipmi="10.0.1.43";
local="127.0.0.3"
ident="/home/ralvarez/.ssh/ralvarez_rsa"

ifconfig lo0 alias ${local} 2> /dev/null;

# Connection between local and proxy server
ssh ${user}@${server} -N \
    -i $ident \
    -L ${local}:80:${ipmi}:80 \
    -L ${local}:443:${ipmi}:443 \
    -L ${local}:8084:${ipmi}:8084 \
    -L ${local}:8091:${ipmi}:8091 \
    -L ${local}:15672:${ipmi}:15672