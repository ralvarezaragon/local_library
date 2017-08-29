#!/usr/bin/env python
from prometheus_client import start_http_server, Summary, Gauge
import urllib
import ssl
import datetime
import re
from time import sleep


def parse_node_name(par):
	switcher = {
		"10.0.6.10": "w1",
		"10.0.6.11": "w2",
		"10.0.6.12": "w3",
		"10.0.6.13": "w4",
		"10.0.6.14": "w5",
		"10.0.6.15": "w6",
		"10.0.6.16": "w7",
		"10.0.6.17": "w8"		
	}	
	return switcher.get(par, par)


def get_metric(l_metric, metric_req, gauge_obj):	
	for metric in l_metric:		
		if metric_req == "version":
			metric_value = metric['apache_version']
		elif metric_req == "req_sec":
			metric_value = metric['req_sec']
		elif metric_req == "current_req":
			metric_value = metric['current_req']
		elif metric_req == "node_load_1":
			metric_value = metric['node_load_1']
		elif metric_req == "node_load_2":
			metric_value = metric['node_load_2']
		elif metric_req == "node_load_3":
			metric_value = metric['node_load_3']
		else:
			metric_value = 0	
		gauge_obj.labels(metric['node']).set(metric_value)	
	return gauge_obj	


if __name__ == '__main__':
  l_metric = []
  start_http_server(8002)
  g_version = Gauge("apache_version", "Apache version", ['node'])
  g_req_sec = Gauge("apache_req_per_sec", "Apache requests per seconds", ['node'])
  g_curr_req = Gauge("apache_current_requests", "Apache current requests", ['node'])
  g_load1 = Gauge("apache_load_1", "Avg node load 1m", ['node'])
  g_load2 = Gauge("apache_load_2", "Avg node load 5m", ['node'])
  g_load3 = Gauge("apache_load_3", "Avg node load 15m", ['node'])
  
  l_node  = [
    '10.0.6.10',
    '10.0.6.11',
    '10.0.6.12',
    '10.0.6.13',
    '10.0.6.14',
    '10.0.6.15',
    '10.0.6.16',
    '10.0.6.17'    
  ]
  while True:
    for node in l_node:
      data = dict()      
      response = urllib.urlopen("http://{0}/apache-status".format(node))
      output = response.read()
      av_raw = re.search('(?<=Server Version: Apache\/)([0-9]*\.[0-9])', output)
      rs_raw = re.search('(?<=<dt>)([0-9\.]*)( requests\/sec)', output)
      cr_raw = re.search('(?<=<dt>)([0-9\.]*)( requests currently being processed, )([0-9\.]*)( idle)', output)
      nl_raw = re.search('(?<=<dt>Server load: )([0-9\.]*)( )([0-9\.]*)( )([0-9\.]*)(<\/dt>)', output)
      data['node'] = parse_node_name(node)
      data['apache_version'] = float(av_raw.group(1))
      data['req_sec'] = rs_raw.group(1)
      data['current_req'] = cr_raw.group(1)
      data['node_load_1'] = nl_raw.group(1)
      data['node_load_2'] = nl_raw.group(3)
      data['node_load_3'] = nl_raw.group(5)
      l_metric.append(data)      
      get_metric(l_metric, "version", g_version)
      get_metric(l_metric, "req_sec", g_req_sec)
      get_metric(l_metric, "current_req", g_curr_req)
      get_metric(l_metric, "node_load_1", g_load1)
      get_metric(l_metric, "node_load_2", g_load2)
      get_metric(l_metric, "node_load_3", g_load3)
      print data
    print "=========================="    
    sleep(5)    