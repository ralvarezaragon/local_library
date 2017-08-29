#!/usr/bin/python

from prometheus_client import start_http_server, Summary, Gauge
import urllib, json
import datetime
import argparse
import requests 
from time import sleep


def get_json_data(url):	
	response = urllib.urlopen(url)
	data = json.loads(response.read())
	return data


def parse_status(par):
	switcher = {
		"healthy": 1,
		"down": 0,
	}
	return switcher.get(par, 0) 


def parse_membership(par):
	switcher = {
		"active": 1,
		"inactive": 0,
	}
	return switcher.get(par, 0) 

	
def parse_node_name(par):
	switcher = {
		"http://10.0.6.10:8092/": "w1",
		"http://10.0.6.11:8092/": "w2",
		"http://10.0.6.12:8092/": "w3",
		"http://10.0.6.13:8092/": "w4",
		"http://10.0.6.14:8092/": "w5",
		"http://10.0.6.15:8092/": "w6",
		"http://10.0.6.16:8092/": "w7",
		"http://10.0.6.17:8092/": "w8",
		"http://10.0.4.2:8092/": "app1",
		"http://10.0.4.5:8092/": "app4",
		"http://10.0.4.6:8092/": "app5",
		"http://10.0.4.7:8092/": "app6"
	}	
	return switcher.get(par, par)


def get_up_node():	
	node_l = ['w1','w2','w3','w4','w5','w6','w7','w8']
	for node in node_l:
		uri = "http://{0}.basebone.com:8091/pools/default/".format(node)
		r = requests.get(uri)
		if r.status_code == 200:
			return uri
		

def get_metric(l_metric, metric_req, gauge_obj, cluster_name):
	l_metric_length = len(l_metric["nodes"])	
	for i in range(l_metric_length):
		node_name = parse_node_name(l_metric["nodes"][i]["couchApiBase"])
		if metric_req == "status":
			metric_value = parse_status(l_metric["nodes"][i]["status"])
		elif metric_req == "membership":
			metric_value = parse_membership(l_metric["nodes"][i]["clusterMembership"])			
		elif metric_req == "mem_total":
			metric_value = l_metric["nodes"][i]["memoryTotal"]
		elif metric_req == "mem_free":
			metric_value = l_metric["nodes"][i]["memoryFree"]		
		elif metric_req == "cpu_usage":
			metric_value = l_metric["nodes"][i]["systemStats"]["cpu_utilization_rate"]	
		elif metric_req == "hdd_size":
			metric_value = l_metric["nodes"][i]["interestingStats"]["couch_docs_actual_disk_size"]	
		elif metric_req == "hdd_used":
			metric_value = l_metric["nodes"][i]["interestingStats"]["couch_docs_data_size"]			
		else:
			metric_value = 0	
		gauge_obj.labels(cluster_name, node_name).set(metric_value)	
	return gauge_obj		


if __name__ == '__main__':
  # setup cb cluster API	
	cb_url = get_up_node()
	#print get_up_node(cb_url_w)
	# Start up the server to expose the metrics.
	start_http_server(8001)	
	# build the metrics
	g_status = Gauge("couchbase_node_status", "couchbase node status", ['cluster', 'node'])
	g_membership = Gauge("couchbase_cluster_membership", "couchbase cluster membership", ['cluster','node'])
	g_mem_total = Gauge("couchbase_node_memory_total_bytes", "couchbase node memory total", ['cluster','node'])
	g_mem_free = Gauge("couchbase_node_memory_free_bytes", "couchbase node memory free", ['cluster','node'])
	g_cpu_usage = Gauge("couchbase_node_cpu_usage", "couchbase node cpu usage", ['cluster','node'])
	g_hdd_size = Gauge("couchbase_node_hdd_size_bytes", "couchbase node hdd size", ['cluster','node'])
	g_hdd_used = Gauge("couchbase_node_hdd_used_bytes", "couchbase node hdd used", ['cluster','node'])

	# Generate some requests.
	while True:
		# Add metric_time for script output
		time = datetime.datetime.time(datetime.datetime.now())
		# open csv for metric extraction
		result = get_json_data(cb_url)
		get_metric(result, "status", g_status, "w1")
		get_metric(result, "membership", g_membership, "w1")		
		get_metric(result, "mem_total", g_mem_total, "w1")
		get_metric(result, "mem_free", g_mem_free, "w1")
		get_metric(result, "cpu_usage", g_cpu_usage, "w1")
		get_metric(result, "hdd_size", g_hdd_size, "w1")
		get_metric(result, "hdd_used", g_hdd_used, "w1")		
		print "{0}::couchbase_node_status:{1}".format(time, cb_url)		
		sleep(5)