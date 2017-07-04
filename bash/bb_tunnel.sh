#!/bin/bash

server="lps3.basebone.com";
user="ralvarez";
local="127.0.0.3"
ident="/home/ralvarez/.ssh/ralvarez_rsa"

ifconfig lo0 alias ${local} 2> /dev/null;

ports=(
    80
    443
    8084
    8091
    15671
)

sudo ssh ${user}@${server} -N \
   -i $ident \
   -L ${local}:80:10.0.50.10:80 \
   -L ${local}:443:10.0.50.10:443 \
   -L ${local}:8091:10.0.6.10:8091 \
   -L ${local}:15672:10.0.6.1:15672