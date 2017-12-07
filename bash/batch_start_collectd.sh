#!/bin/bash

today=`date +%Y%m%d`
declare -a container_list=("w1.basebone.com" "w2.basebone.com" "w3.basebone.com" "w4.basebone.com" "w5.basebone.com" "w6.basebone.com" "w7.basebone.com" "w8.basebone.com");

echo "> Start collectd all over the servers"
for container in "${container_list[@]}"; do
    echo ">> Starting Collectd for ${container}"
    ssh ${container} "sudo service collectd start" 2>&1 > /dev/null
    echo ">> Collectd running"
done
echo "> Done, bye"