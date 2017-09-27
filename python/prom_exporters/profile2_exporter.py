#!/usr/bin/python
import re
from prometheus_client import start_http_server, Summary, Counter
import glob, os
import datetime

def parse_ip(par):
	switcher = {
    "10.0.3.1": "hopper",
		"10.0.3.21": "hopper1",
		"10.0.3.22": "hopper2",
		"10.0.3.23": "hopper3",
    "10.0.3.5": "stats_read",
    "10.0.3.6": "stats_write",
		"10.0.3.50": "stats1",
		"10.0.3.51": "stats2",
		"10.0.3.53": "stats4",
    "10.0.3.8": "fargo_read",
    "10.0.3.9": "fargo_write",
    "10.0.3.30": "fargo1",
    "10.0.3.31": "fargo2",
    "10.0.3.32": "fargo3",
    "10.0.3.7": "frank",
    "10.0.3.40": "frank1",
		"10.0.3.41": "frank2",
		"10.0.3.42": "frank3"		
	}	
	return switcher.get(par, par)


start_http_server(8005)
c = Counter('mysql_profile2', 'Mysql profiling metrics from PHP logs', ['source', 'target', 'dbname', 'module', 'query_type'])

log_file = max(glob.iglob('/smsc/var/log/mysql_php_*.log'), key=os.path.getctime)
hour_substr = re.search('^(.smsc.var.log.mysql_php_\d+.\d+.\d+-)(\d+)(.log)', log_file)
hour_file = int(hour_substr.group(2))

with open(log_file) as f:
  while True:
		hour_now = int(datetime.date.now().hour)
		line = f.readline()    
    print "{0} | {1}".format(hour_file, hour_now)
    if line and hour_file == hour_now:
      query = dict()
      #print line      
      row_substr = re.search('^([\d:]*) (\S*) (\S*)  (\S*) (\w*): ([\d\.]*) (\S*) (\S*) (.*\*\/) (\S*)', line)
      try:
        ts = row_substr.group(1)
      except Exception as e:
        ts = ''
      query['source'] = 'PHP'
      try:
        query['DUNNO'] = row_substr.group(2)
      except Exception as e:
        query['DUNNO'] = ''
      try:
        query['module'] = row_substr.group(5)
      except Exception as e:
        query['module'] = ''
      try:  
        query['target'] = parse_ip(row_substr.group(6))
      except Exception as e:
        query['target'] = ''
      try:
        query['dbname'] = row_substr.group(7)
      except Exception as e:
        query['dbname'] = ''
      try:
        query['type'] = row_substr.group(9)
      except Exception as e:
        query['type'] = ''
      c.labels(source = query['source'], target = query['target'], dbname = query['dbname'], module = query['module'], query_type = query['type']).inc()      
      print "{0}.- {1}".format(ts, query)