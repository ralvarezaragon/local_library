#!/bin/bash

cd /home/ralvarez/Downloads/logs

logfile=$1
current='00:00'
end='23:45'
while [ ${current} != ${end} ]; do
    prev=${current}
    prev_hour=`echo $prev | awk -F ':' '{print $1}'`
    prev_min=`echo $prev | awk -F ':' '{print $2}'`
    current=`date -d "${current} 15 minutes" +'%H:%M'`
    current_hour=`echo $current | awk -F ':' '{print $1}'`
    current_min=`echo $current | awk -F ':' '{print $2}'`
    echo "${prev_hour}:${prev_min} | ${current_hour}:${current_min}"
    new_logfile=`echo ${logfile} | awk -F '.log' '{print $1}'`
    new_logfile="${new_logfile}_${prev}_.log"
    #cat $logfile | grep ^$current > /home/ralvarez/Downloads/logs/split/$new_logfile
    #sed '/^${prev}/,/^${current}/p' ${logfile} > /home/ralvarez/Downloads/logs/split/$new_logfile
    cat pixel_2017.10.16.log | awk -F':' '$1 >= ${prev_hour} && $1 <= ${current_hour} && $2 >= ${prev_min} && $2 <= ${current_min} { print }' > /home/ralvarez/Downloads/logs/split/$new_logfile
    #sed '/^${prev}/,/^${current}/p' ${logfile}
done
echo 'done'


