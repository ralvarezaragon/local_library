import json
import os
import glob
import fnmatch


def parse_json(p):
    with open(p) as json_data:
        output = json.load(json_data)
    return output


def write_to_json(p, d):
  with open(p, mode='w') as f:
    f.write(json.dumps(d, indent=2))


def add_to_json(p, new_data):
  feed = parse_json(p)
  if to_add not in feed["filename"]:
    feed["filename"].append(new_data)
    write_to_json(p, feed)
    
# Declare json file list file    
f_path = 'file_list.json'
# Download files from S3
#os.system("aws s3 sync s3://basebone.backups/cost_reports/daily_summary/ /tmp/aws_out/}")
# Read each csv.gz file and uncompress
for root, dirnames, filenames in os.walk("/tmp/aws_out/"):
  for filename in fnmatch.filter(filenames, '*.csv.gz'):
    print filename

to_add_list = []
# Add list to json file
for to_add in to_add_list:
  add_to_json(f_path, to_add)




  
  
#"aws s3 sync s3://basebone.backups/cost_reports/daily_summary/ /tmp/" 