#!/usr/bin/python

import subprocess as sub
import re


p = sub.Popen(('sudo', 'tcpdump', '-i', 'eno2', '-s', '0', '-l', '-w', '-', 'dst', 'port 3306'), stdout=sub.PIPE)
for row in iter(p.stdout.readline, b''):  
  if row.find('INSERT', beg=0, end=len(string) > -1):
    print ("insert counted")