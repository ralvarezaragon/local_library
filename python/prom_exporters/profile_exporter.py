#!/usr/bin/python

import pyshark

capture = pyshark.LiveCapture(interface='rpcapd://10.0.3.53:3306/eno2')
capture.sniff(timeout=50)

for packet in capture.sniff_continuously(packet_count=5):
    print packet