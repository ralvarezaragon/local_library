#!/usr/bin/python

from prometheus_client import CollectorRegistry, Gauge, push_to_gateway
import urllib
import datetime
import argparse
import subprocess
from time import sleep

def replace_str(s, pat, repl):
  for element in pat:
    s = s.replace(element, repl)
  return s  


def get_cpu_usage(h):
  repl_list = ["\n", "id"]
  #output_raw = subprocess.check_output("vmstat | awk {'print $15'}", shell=True)
  output_raw = subprocess.check_output("ssh " + h + " vmstat | awk {'print $15'}", shell=True)  
  output_str = int(replace_str(output_raw, repl_list, ""))  
  return output_str


def get_metric(l_metric, metric_req, gauge_obj):
	l_metric_length = len(l_metric)	
	for i in range(l_metric_length):
		node_name = parse_node_name(l_metric["nodes"][i]["couchApiBase"])
		if metric_req == "status":
			metric_value = parse_status(l_metric["nodes"][i]["status"])		
		else:
			metric_value = 0	
		gauge_obj.labels(cluster_name, node_name).set(metric_value)	
	return gauge_obj


if __name__ == '__main__':
  start_http_server(8002)
  l_hostname = ["backup1.basebone.com"]
  g_cpu_usage = Gauge("host_cpu_usage", "host cpu usage", ['node'])
  while True:
    time = datetime.datetime.time(datetime.datetime.now())
    for host in l_hostname:
      cpu_usage = get_cpu_usage()
      gauge_obj.labels(host).set(cpu_usage)	
      print "{0}::couchbase_node_status:cpu_usage".format(time)		
    sleep(5)