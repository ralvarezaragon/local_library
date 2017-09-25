#!/usr/bin/python

import argparse
from pyspark import SparkContext, SparkConf
import boto3
import re

       
def distributed_file_read(file_key):
  s3_obj = boto3.resource('s3').Object(bucket_name='basebone.backups', key=file_key)
  body = s3_obj.get()['Body'].read()
  # Cleanup rubbish chars
  body = re.sub('[\[\]>]', '', body)
  body = re.sub('State|Type:|MT:|P:|E:|N:|C:|TID:|R:', '', body)
  # Split the body by lines so now we have a list of elements 
  l_res = body.splitlines()
  return l_res

def split_line(line):
  l_res = line.split(" ")
  l_res = filter(None, l_res)
  return l_res        

  
# Open the bucket
s3 = boto3.resource('s3')
bucket = s3.Bucket('basebone.backups')
l_key = []
# List the files within the desired folder for the given bucket
for s3_file in bucket.objects.filter(Prefix='test_log/'):
  l_key.append(s3_file.key)
  print "  >>> New file added: {0}".format(s3_file.key)
 
# Get a Spark context and use it to parallelize the keys
conf = SparkConf().setAppName("apptest1")
sc = SparkContext(conf=conf)
sc_key = sc.parallelize(l_key)
rdd = sc_key.flatMap(distributed_file_read)
print "  >>> Count of row: {0}".format(rdd.count())
#rdd1 = rdd.map(split_line)
#print rdd1.collect()
print "Done"



