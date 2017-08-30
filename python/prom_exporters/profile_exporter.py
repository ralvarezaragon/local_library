#!/usr/bin/python

import subprocess as sub

p = sub.Popen(('sudo', 'tcpdump', '-l port 3306'), stdout=sub.PIPE)
for row in iter(p.stdout.readline, b''):
    print row.rstrip()   # process here