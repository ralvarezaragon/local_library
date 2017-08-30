#!/usr/bin/python

import subprocess as sub
import re


p = sub.Popen(('sudo', 'tcpdump', '-i', 'eno2', '-s', '0', '-l', '-w', '-', 'dst', 'port 3306'), stdout=sub.PIPE)
for row in iter(p.stdout.readline, b''):  
  if row.find('INSERT') > -1:
    query_obj = re.search('(?<=INSERT INTO `)([a-z_0-9]*)`.`([a-z_0-9]*)', row)
    query['dbname'] = dbname_obj.group(0)
    query['tname'] = dbname_obj.group(1)
    query['type'] = 'INSERT'
    print query
  else:
    print row.rstrip()