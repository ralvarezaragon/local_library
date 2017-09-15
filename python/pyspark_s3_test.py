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
                
# Get menu parameters
opt = option_menu()
# OPen S3 session wiht given credentials
#session = Session(
#  aws_access_key_id=opt.access_key,
#  aws_secret_access_key=opt.secret_key
#)
#s3 = session.resource('s3')
# Open the bucket
#bucket = s3.Bucket('basebone.backups')
#keys = []
# List the files within the desired folder
#for s3_file in bucket.objects.filter(Prefix='test_log'):
#  keys.append(s3_file.key)
  
# Get a Spark context and use it to parallelize the keys
conf = SparkConf().setAppName("apptest1")
sc = SparkContext(conf=conf)
#sc.hadoopConfiguration.set("fs.s3n.awsAccessKeyId", opt.access_key)
#sc.hadoopConfiguration.set("fs.s3n.awsSecretAccessKey", opt.secret_key)
rdd = sc.textFile("s3n://basebone.backups/test_log/13.log")
print rdd.count
#rdd = sc.parallelize(keys)


# Call the map step to handle reading in the file contents
#activation = pkeys.flatMap(map_func)
