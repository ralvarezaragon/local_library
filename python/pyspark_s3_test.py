#!/usr/bin/python

import argparse
from pyspark import SparkContext, SparkConf
from boto.s3.connection import S3Connection


def option_menu():
  parser = argparse.ArgumentParser()
  parser.add_argument(
    '--access_key', metavar='a', dest='access_key', type=str,
    help="Select the target cluster [hopper|stats|frank]"
  )
  parser.add_argument(
    '--secret_key', metavar='s', dest='secret_key', type=str, 
    help="Declare the target database"
  )  
  args = parser.parse_args()
  return args

opt = option_menu()
conn = S3Connection(
    opt.access_key,
    opt.secret_key
)
bucket = conn.get_bucket('basebone.backups')
keys = bucket.list()
print keys
  # Get a Spark context and use it to parallelize the keys
  #conf = SparkConf().setAppName("MyFileProcessingApp")
  #sc = SparkContext(conf=conf)
  #pkeys = sc.parallelize(keys)
  # Call the map step to handle reading in the file contents
  #activation = pkeys.flatMap(map_func)
