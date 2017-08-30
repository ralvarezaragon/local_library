#!/usr/bin/python

import subprocess as sub

p = sub.Popen(('sudo', 'tcpdump', '-i', 'eno2', '-l', 'port 3306'), stdout=sub.PIPE)
for row in iter(p.stdout.readline, b''):    
    print row