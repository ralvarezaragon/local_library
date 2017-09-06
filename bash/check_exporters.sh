#!/bin/bash

function msg_out {
    msg=$1
    date=`date +"%Y-%m-%d %H:%M:%S"`
    echo "$date::$msg"
}

declare -a exporter_list=("haproxy" "couchbase");

for exporter in "${exporter_list[@]}"; do
  active=$(ps aux |grep python | grep ${exporter})  
  if [ ${#active} -gt 1 ]; then
    msg_out "${exporter} exporter is active"
  else
    msg_out "${exporter} exporter is inactive. Trying to start the service... "
    /etc/init.d/${exporter}_daemon start 2>&1 > /dev/null && msg_out " ...success" || msg_out " ...failed"
  fi;
done;