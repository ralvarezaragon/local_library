#!/usr/bin/python
import re
import pandas as pd
import multiprocessing as mp
from functools import partial


def parse_ip(par):
	switcher = {
    "10.0.3.1": "hopper",
		"10.0.3.21": "hopper1",
		"10.0.3.22": "hopper2",
		"10.0.3.23": "hopper3",
    "10.0.3.5": "stats_read",
    "10.0.3.6": "stats_write",
		"10.0.3.50": "stats1",
		"10.0.3.51": "stats2",
		"10.0.3.53": "stats4",
    "10.0.3.8": "fargo_read",
    "10.0.3.9": "fargo_write",
    "10.0.3.30": "fargo1",
    "10.0.3.31": "fargo2",
    "10.0.3.32": "fargo3",
    "10.0.3.7": "frank",
    "10.0.3.40": "frank1",
		"10.0.3.41": "frank2",
		"10.0.3.42": "frank3"
	}
	return switcher.get(par, par)


def process_frame(df):
  df = df.ix[:, 0].str.extract('^(.*) (\w+) (\w+).  (\w+) (\w+). (\S+) (\w+) (\w+) (.*\*\/) (\S*)')
  df = df.dropna(how='all')
  return df


filename = '/home/ralvarez/Downloads/mysql_php_2017.09.27-09.log'
chunk_size = 100000


if __name__ == '__main__':
  reader = pd.read_table(filename, chunksize = chunk_size)
  pool = mp.Pool(3)
  for df in reader:
    #df = df.ix[:, 0].rename('raw')
    #f = pool.apply_async(process_frame, [df])
    f = pool.map_async(process_frame, [df])
    print f

    #funclist.append(df)


  #result = 0
  ##for f in funclist:
  #  result += f.get(timeout=10)  # timeout in 10 seconds

  #print "There are %d rows of data" % (result)


  
  
