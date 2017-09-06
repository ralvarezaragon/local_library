#!/usr/bin/python

import os
import subprocess
import argparse


def option_menu():
  parser = argparse.ArgumentParser()
  parser.add_argument(
    '--target', metavar='c', dest='target', type=str, choices=["hopper", "stats", "frank", "hopper1", "hopper2", "hopper2", "stats1", "stats2", "stats3", "frank1", "frank2", "frank3", "all"],
    help="Select the target cluster [hopper1..3|stats1..3|frank1..3|all]"
  )
  parser.add_argument(
    '--cmd', metavar='d', dest='cmd', type=str, 
    help="The command to run"
  ) 
  args = parser.parse_args()
  return args


opt = option_menu()
if (opt.target == "hopper"):
  l_target = ['hopper1.basebone.com', 'hopper2.basebone.com', 'hopper3.basebone.com']
elif (opt.target == "stats"):
  l_target = ['stats1.basebone.com', 'stats2.basebone.com', 'stats4.basebone.com']
elif (opt.target == "frank"):
  l_target = ['frank1.basebone.com', 'frank2.basebone.com', 'frank3.basebone.com']
elif (opt.target == "all"):
  l_target = [
    'hopper1.basebone.com', 'hopper2.basebone.com', 'hopper3.basebone.com',
    'stats1.basebone.com', 'stats2.basebone.com', 'stats4.basebone.com',
    'frank1.basebone.com', 'frank2.basebone.com', 'frank3.basebone.com'
  ]
else:
  l_target=['{0}.basebone.com'.format(opt.target)]
  
shell_cmd = "ssh -i /remote/.ssh/id_rsa sshsync@{0} {1}".format(opt.target, opt.cmd)
output = subprocess.check_output(shell_cmd, shell=True)
print output