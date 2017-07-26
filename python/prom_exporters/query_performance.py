#!/usr/bin/python

from prometheus_client import start_http_server, Summary, Gauge
import urllib
import datetime
import argparse
import subprocess
from time import sleep
import MySQLdb


def open_mysql_conn(conn_array):
  new_conn = MySQLdb.connect(
    host=conn_array["host"],
    user=conn_array["user"],
    passwd=conn_array["pwd"],
    db="mysql"
  )
  return new_conn



def get_active_queries_info(c):
  conn = open_mysql_conn(c)
  cur = conn.cursor()
  cur.execute("select count(*) as c, avg(time_ms) as av from information_schema.processlist where  command !='Sleep' and info not like '%information_schema.processlist%'")
  res = cur.fetchone()
  conn.close()
  return res


def get_metric(l_host, result, metric_req, gauge_obj):
	l_metric_length = len(l_host)	
	for i in range(l_metric_length):		
		if metric_req == "count":
			metric_value = result['c']
		elif metric_req == "time":
			metric_value = result['av']				
		else:
			metric_value = 0	
		gauge_obj.labels(node_name).set(metric_value)	
	return gauge_obj	


if __name__ == '__main__':
  # setup mysql cluster conn
  conn = {}
  conn["user"] = 'admin'
  conn["pwd"] = 'wastinglightdearrosemary'
  l_node  = [
    'hopper1.basebone.com',
    'hopper2.basebone.com',
    'hopper3.basebone.com',
    'stats1.basebone.com',
    'stats2.basebone.com',
    'stats4.basebone.com',
    'frank1.basebone.com',
    'frank2.basebone.com',
    'frank3.basebone.com'
  ]
  dict_metric = {}
  # Start up the server to expose the metrics.
  start_http_server(8003)	
  # build the metrics
  g_count = Gauge("mysql_active_query_count", "amount of active queries running", ['node'])
  g_time = Gauge("mysql_acive_query_time_ms", "avg time on ms of active queries running", ['node']) 

  # Generate some requests.
  while True:
    # Add metric_time for script output
    time = datetime.datetime.time(datetime.datetime.now())
    # open query for metric extraction
    for node in l_node:
      conn["host"] = node
      #result = get_active_queries_info(conn)
      dict_metric.append({'count': result['c'], 'time': result['av']})
      print (conn["host"])
    #get_metric(conn["host"], result, "count", g_count)
    #get_metric(conn["host"], result, "time", g_time)		
    #print "{0}::mysql_query_count and time running".format(time)
#print (dict_metric)
    sleep(5)
