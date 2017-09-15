#!/usr/bin/python

import argparse
from pyspark import SparkContext, SparkConf
from boto3.session import Session

def option_menu():
  parser = argparse.ArgumentParser()
  parser.add_argument(
    '--access_key', metavar='a', dest='access_key', type=str,
    help="Identify yourself with the key"
  )
  parser.add_argument(
    '--secret_key', metavar='s', dest='secret_key', type=str, 
    help="the secret for teh access key"
  )  
  args = parser.parse_args()
  return args

opt = option_menu()

#conn = S3Connection(
#    opt.access_key,
#    opt.secret_key
#)
#bucket = conn.get_bucket('basebone.backups')
#keys = bucket.list()
#print keys

session = Session(
  aws_access_key_id=opt.access_key,
  aws_secret_access_key=opt.secret_key
)
s3 = session.resource('s3')
bucket = s3.Bucket('basebone.backups')


     
for s3_file in bucket.objects.all():
  for key in bucket.objects.all():
        print(key.key)  

  # Get a Spark context and use it to parallelize the keys
  #conf = SparkConf().setAppName("MyFileProcessingApp")
  #sc = SparkContext(conf=conf)
  #pkeys = sc.parallelize(keys)
  # Call the map step to handle reading in the file contents
  #activation = pkeys.flatMap(map_func)
