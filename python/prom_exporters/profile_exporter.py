#!/usr/bin/python

import subprocess as sub

p = sub.Popen(('sudo', 'tcpdump -i eno2 -s 0 -l -w - dst port 3306 | strings | egrep "SELECT|INSERT|DELETE|UPDATE|ALTER|DROP|CREATE|REPLACE|CALL" | grep -v "SELECT 1"', '-l'), stdout=sub.PIPE)
for row in iter(p.stdout.readline, b''):
    print row.rstrip()   # process here