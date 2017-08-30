#!/usr/bin/python

import subprocess as sub
import re

query = dict()
p = sub.Popen(('sudo', 'tcpdump', '-i', 'eno2', '-s', '0', '-l', '-w', '-', 'dst', 'port 3306'), stdout=sub.PIPE)
for row in iter(p.stdout.readline, b''):  
  if row.find('INSERT') > -1:
    row_substr = re.search('(INSERT INTO `)([a-z_0-9]*)`.`([a-z_0-9]*)', row)
    query['dbname'] = row_substr.group(1)
    query['tname'] = row_substr.group(2)
    query['type'] = 'INSERT'
   
  elif row.find('SELECT *') > -1:
    print row.rstrip()
    row_substr = re.search('(SELECT .* FROM `)([a-z_0-9]*)`.`([a-z_0-9]*)', row)
    query['dbname'] = row_substr.group(1)
    query['tname'] = row_substr.group(2)
    query['type'] = 'SELECT'
    
  print query
  print "==========================="