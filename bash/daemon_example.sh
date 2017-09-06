#! /bin/sh
# This file goes in /etc/init.d/example
sname="couchbase"
 
case "$1" in
  start)
    echo "Starting ${sname} exporter"
    # run application you want to start
    python /opt/${sname}_exporter.py &
    ;;
  stop)
    echo "Stopping ${sname} exporter"
    # kill application you want to stop
    pid=`ps aux | grep python | grep ${sname} | awk '{print $2}'`
    kill $pid
    ;;
  *)
    echo "Usage: /etc/init.d/${sname}_daemon{start|stop}"
    exit 1
    ;;
esac
 
exit 0
