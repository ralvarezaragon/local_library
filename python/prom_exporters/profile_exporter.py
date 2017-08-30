#!/usr/bin/python

import subprocess as sub

p = sub.Popen(('sudo', 'tcpdump', '-n', '-i', 'eno2', '-s', '0', '-l', 'dst', 'port 3306', '|', 'strings'), stdout=sub.PIPE)
for row in iter(p.stdout.readline, b''):    
    print row.rstrip()