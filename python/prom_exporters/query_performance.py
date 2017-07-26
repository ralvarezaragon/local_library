#!/usr/bin/python

from prometheus_client import start_http_server, Summary, Gauge
import urllib
import datetime
import argparse
import subprocess
from time import sleep
import os
import subprocess


def get_active_queries_info(host):
  cmd = "mysql -h {0} -e 'show processlist' | grep Query | awk -F'\t' '{{print $6}}'".format(host)
  os.system(cmd)
  return os.system(cmd)


def get_active_queries_info_new(host):
  cmd = "mysql -h {0} -e 'show processlist' | grep Query | awk -F'\t' '{{print $6}}'".format(host)
  output = subprocess.check_output(cmd, shell=True)
  return output


def parse_node_name(par):
	switcher = {
		"10.0.3.21": "hopper1",
		"10.0.3.22": "hopper2",
		"10.0.3.23": "hopper3",
		"10.0.3.50": "stats1",
		"10.0.3.51": "stats2",
		"10.0.3.53": "stats4",
		"10.0.3.40": "frank1",
		"10.0.3.41": "frank2",
		"10.0.3.42": "frank3"		
	}	
	return switcher.get(par, par)


def get_metric(l_metric, metric_req, gauge_obj):	
	for metric in l_metric:		
		if metric_req == "count":
			metric_value = metric['count']
		elif metric_req == "time":
			metric_value = metric['time']				
		else:
			metric_value = 0	
		gauge_obj.labels(metric['node']).set(metric_value)	
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
  l_metric = []
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
      result_list = result.split('\n')
      del result_list[-1]
      result_list = map(int, result_list)
      l_metric.append ({'node' : parse_node_name(node), 'count' : len(result_list), 'time' : round(sum(result_list) / float(len(result_list)), 2)})
    get_metric(l_metric, "count", g_count)
    #get_metric(conn["host"], result, "time", g_time)		
    #print "{0}::mysql_query_count and time running".format(time)
    print (l_metric)
    sleep(5)
