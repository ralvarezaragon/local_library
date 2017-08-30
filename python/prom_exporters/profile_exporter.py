#!/usr/bin/python

import subprocess as sub
import re


p = sub.Popen(('sudo', 'tcpdump', '-i', 'eno2', '-s', '0', '-l', '-w', '-', 'dst', 'port 3306'), stdout=sub.PIPE)
for row in iter(p.stdout.readline, b''):
  query = dict()
  if row.find('INSERT') > -1:
    row_substr = re.search('(INSERT INTO `)([a-z_0-9]*)`.`([a-z_0-9]*)', row)
    query['dbname'] = row_substr.group(2)
    query['tname'] = row_substr.group(3)
    query['type'] = 'INSERT'   
  elif row.find('SELECT ') > -1 and row.find('SELECT 1') == -1:    
    row_substr = re.search('(SELECT .* FROM `)([a-z_0-9]*)`.`([a-z_0-9]*)', row)
    query['dbname'] = row_substr.group(2)
    query['tname'] = row_substr.group(3)
    query['type'] = 'SELECT'
  elif row.find('UPDATE') > -1 or row.find('DELETE') > -1 or row.find('DROP') > -1:
    query['dbname'] = 'NA'
    query['tname'] = 'NA'
    query['type'] = row.rstrip()
  print query
  print "==========================="