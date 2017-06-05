#! /bin/sh
# This file goes in /etc/init.d/example
 
case "$1" in
  start)
    echo "Starting couchbase exporter"
    # run application you want to start
    python /opt/couchbase_exporter/couchbase_exporter.py &
    ;;
  stop)
    echo "Stopping couchbase exporter"
    # kill application you want to stop
    pid=`ps aux | grep python | grep couchbase | grep $1 | awk '{print $2}'`
    kill $pid
    ;;
  *)
    echo "Usage: /etc/init.d/couchbase_daemon{start|stop}"
    exit 1
    ;;
esac
 
exit 0
