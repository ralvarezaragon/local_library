#!/usr/bin/python

import argparse
from pyspark import SparkContext, SparkConf
from boto.s3.connection import S3Connection


def main():
  bucket = conn.get_bucket('basebone.backups')
  keys = bucket.list()
  print keys
  # Get a Spark context and use it to parallelize the keys
  #conf = SparkConf().setAppName("MyFileProcessingApp")
  #sc = SparkContext(conf=conf)
  #pkeys = sc.parallelize(keys)
  # Call the map step to handle reading in the file contents
  #activation = pkeys.flatMap(map_func)