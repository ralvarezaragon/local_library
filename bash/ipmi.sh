#!/bin/bash

server="$1";
ipmi="$2";
user="ralvarez";
local="127.0.0.2"
ident="/home/ralvarez/.ssh/ralvarez_rsa"

ifconfig lo0 alias ${local} 2> /dev/null;

ssh ${user}@${server} -N \
    -i $ident \
    -L ${local}:80:${ipmi}:80 \
    -L ${local}:82:${ipmi}:80 \
    -L ${local}:5900:${ipmi}:5900 \
    -L ${local}:5901:${ipmi}:5901 \
    -L ${local}:5120:${ipmi}:5120 \
    -L ${local}:5123:${ipmi}:5123 \
    -L ${local}:623:${ipmi}:623 \
    -L ${local}:443:${ipmi}:443
