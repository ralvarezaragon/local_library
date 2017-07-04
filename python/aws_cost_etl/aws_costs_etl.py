#!/usr/bin/python

import json
import os
import glob
import fnmatch
import datetime
import pandas as pd


def get_from_s3():
    os.system("rm -r /tmp/aws_out/")
    os.system("aws s3 sync s3://basebone.backups/cost_reports/daily_summary/ /tmp/aws_out/")
    
def parse_json(p):
    with open(p) as json_data:
        output = json.load(json_data)
    return output


def write_to_json(p, d):
  with open(p, mode='w') as f:
    f.write(json.dumps(d, indent=2))


def add_to_json(p, new_data):
  feed = parse_json(p)
  if new_data not in feed["filename"]:
    feed["filename"].append(new_data)
    write_to_json(p, feed)
 

def uncompress_files(fl):
    for root, dirnames, filenames in os.walk("/tmp/aws_out/"):
        if root not in fl["filename"]:
            for filename in fnmatch.filter(filenames, '*.csv.gz'):                 
                full_path = "{0}/{1}".format(root, filename)
                os.system("gunzip {0}".format(full_path))
                print "{0} uncompressed".format(full_path)
            

def process_csv(df, fl):
    for root, dirnames, filenames in os.walk("/tmp/aws_out/"):
        if root not in fl["filename"]:
            for filename in fnmatch.filter(filenames, '*.csv'):            
                uncompressed_csv = "{0}/{1}".format(root, filename)
                csv_data = pd.read_csv(uncompressed_csv)
                df = pd.concat([df, csv_data])                
                print "{0} processed".format(uncompressed_csv)
    return df        
            
if __name__ == '__main__':                
# Declare json file list file    
    f_path = 'file_list.json'
    # Get the current filename list from json
    existing_file_list = parse_json(f_path)
    # Download files from S3
    get_from_s3()
    # Define final_df for data frames aggregations
    final_df = pd.DataFrame()    
    # Read each csv.gz file and uncompress
    uncompress_files(existing_file_list)
    # Process teh uncrompressed files into a data frame
    final_df = process_csv(final_df, existing_file_list)    
    final_df = final_df.drop_duplicates(subset=['identity/LineItemId','lineItem/UsageStartDate'], keep='first')
    output_filename = 'aws_costs_{0}.csv'.format(datetime.datetime.now().date())
    final_df.to_csv(output_filename, sep=';')

    
# Insert into json file to keep track and exclude next time
#add_to_json(f_path, root)
            
# Add list to json file
#for to_add in to_add_list:
#  add_to_json(f_path, to_add)




  
  
#"aws s3 sync s3://basebone.backups/cost_reports/daily_summary/ /tmp/" 