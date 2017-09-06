#!/usr/bin/python
from prometheus_client import start_http_server, Summary, Counter
import subprocess as sub
import re
import socket


def get_insert_row(row):
  row_substr = re.search('(INSERT INTO `)([a-z_0-9]*)`.`([a-z_0-9]*)', row)
  query['dbname'] = row_substr.group(2)
  query['tname'] = row_substr.group(3)
  query['type'] = 'INSERT'
  return query


def get_select_row(row):
  row_substr = re.search('SELECT .* FROM `([a-z_0-9]*)`.`([a-z_0-9]*)', row)
  query['dbname'] = row_substr.group(1)
  query['tname'] = row_substr.group(2)
  query['type'] = 'SELECT'
  return query


def get_update_row(row):
  row_substr = re.search('(UPDATE `)([a-z_0-9]*)`.`([a-z_0-9]*)(` SET )', row)
  query['dbname'] = row_substr.group(2)
  query['tname'] = row_substr.group(3)
  query['type'] = 'SELECT'
  return query


def get_replace_row(row):
  row_substr = re.search('(REPLACE INTO `)([a-z_0-9]*)`.`([a-z_0-9]*)', row)
  query['dbname'] = row_substr.group(2)
  query['tname'] = row_substr.group(3)
  query['type'] = 'REPLACE'
  return query

start_http_server(8004)
c = Counter('mysql_profile', 'Mysql profiling metrics', ['exported_instance', 'dbname', 'tname', 'type'])
p = sub.Popen(('sudo', 'tcpdump', '-i', 'eno2', '-s', '0', '-l', '-w', '-', 'dst', 'port 3306'), stdout=sub.PIPE)
for row in iter(p.stdout.readline, b''):
  query = dict()
  query['exported_instance'] = socket.gethostname()
  if row.find('INSERT') > -1:
    try:
      print get_insert_row(row)
      c.labels(dbname = query['dbname'], tname = query['tname'], type = query['type']).inc()
    except Exception as e:
      err = 1    
  elif row.find('SELECT ') > -1 and row.find(' FROM') > -1:
    try:
      print get_select_row(row)
      c.labels(dbname = query['dbname'], tname = query['tname'], type = query['type']).inc()
    except Exception as e:
      err = 1 
  elif row.find('UPDATE') > -1 and row.find('SET') > -1:
    try:  
      print get_update_row(row)
      c.labels(dbname = query['dbname'], tname = query['tname'], type = query['type']).inc()
    except Exception as e:
      err = 1
  elif row.find('REPLACE INTO ') > -1:
    try:  
      print get_replace_row(row)
      c.labels(dbname = query['dbname'], tname = query['tname'], type = query['type']).inc()
    except Exception as e:
      err = 1     
  elif (row.find('DELETE') > -1 and row.find(' FROM') > -1):
      print row.rstrip()
      exit()
  # Catch value and export it to prom in metric format    
  