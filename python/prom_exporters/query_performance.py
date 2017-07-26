#!/usr/bin/python

from prometheus_client import start_http_server, Summary, Gauge
import urllib
import datetime
import argparse
import subprocess
from time import sleep
import MySQLdb
import os
import subprocess


def get_active_queries_info(host):
  cmd = "mysql -h {0} -e 'show processlist' | grep Query | awk -F'\t' '{{print $6}}'".format(host)
  os.system(cmd)
  return os.system(cmd)

def get_active_queries_info_new(host):
  cmd = "mysql -h {0} -e 'show processlist' | grep Query | awk -F'\t' '{{print $6}}'".format(host)
  output = subprocess.check_output(CMD, shell=True)
  return output

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
    '10.0.3.21',
    '10.0.3.22',
    '10.0.3.23',
    '10.0.3.50',
    '10.0.3.51',
    '10.0.3.53',
    '10.0.3.40',
    '10.0.3.41',
    '10.0.3.42'
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
      result = get_active_queries_info_new(node)      
      #dict_metric['count'] = result['c'],
      #dict_metric['time'] = result['av']
      print("=================== {0} ========================".format(node))
      print output.split('\n')
    #get_metric(conn["host"], result, "count", g_count)
    #get_metric(conn["host"], result, "time", g_time)		
    #print "{0}::mysql_query_count and time running".format(time)
#print (dict_metric)
    sleep(5)
