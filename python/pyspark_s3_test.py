#!/usr/bin/python

import argparse
from pyspark import SparkContext, SparkConf
import boto3

       
def distributed_file_read(file_key):
    s3_obj = boto3.resource('s3').Object(bucket_name='basebone.backups', key=file_key)
    body = s3_obj.get()['Body'].read()
    return body
        
        
# Open the bucket
s3 = boto3.resource('s3')
bucket = s3.Bucket('basebone.backups')
l_key = []
# List the files within the desired folder for the given bucket
for s3_file in bucket.objects.filter(Prefix='test_log'):
  l_key.append(s3_file.key)
 
print distributed_file_read(l_key[0])
# Get a Spark context and use it to parallelize the keys
#conf = SparkConf().setAppName("apptest1")
#sc = SparkContext(conf=conf)

#pkeys = sc.parallelize(l_key) #keyList is a list of s3 keys
#rdd = pkeys.flatMap(distributed_file_read)
#rdd = sc.textFile("s3n://basebone.backups/test_log/13.log")
#print rdd.count