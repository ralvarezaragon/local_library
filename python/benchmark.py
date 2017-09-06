#!/usr/bin/python
import os

user = 'admin'
password = 'wastinglightdearrosemary'

# mysql benchmarking
tran_list = [10000, 100000, 1000000]

for tran in tran_list:
  cmd = "sysbench --test=oltp --oltp-table-size={0} --mysql-db=test --mysql-user={1} --mysql-password={2} prepare".format(tran, user, password)
  os.system(cmd)
  cmd = "sysbench --test=oltp --oltp-table-size={0} --mysql-db=test --mysql-user={1} --mysql-password={2} --max-time=60 --oltp-read-only=on --max-requests=0 --num-threads=8 run".format(tran, user, password)
  os.system(cmd)
  cmd = "sysbench --test=oltp --mysql-db=test --mysql-user={1} --mysql-password={2} cleanup".format(tran, user, password)
  os.system(cmd)