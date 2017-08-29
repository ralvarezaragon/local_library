#!/usr/bin/python
import csv
import re
import sys
import pandas as pd

csv.field_size_limit(sys.maxsize)
input_l = list(csv.reader(open('query_11_30.log', 'rb'), delimiter='\t'))
df = pd.DataFrame(columns=('query_type', 'dbname'))

for entry in input_l:
  try:    
    query = entry[2]
    if query.startswith("INSERT"):
      dbname_obj = re.search('(?<=INSERT INTO `)([a-z_0-9]*)', query)
      dbname = dbname_obj.group(0)
      query_type = 'INSERT'
    elif query.startswith("SELECT * FROM"):   
      dbname_obj = re.search('(?<=SELECT * FROM `)([a-z_0-9]*)', query)
      dbname = dbname_obj.group(0)
      query_type = 'SELECT'
    elif query.startswith("SELECT 1") or query.startswith("SET ") or query.startswith("set "):   
      dbname = 'No DB'      
      query_type = 'SELECT'           
    elif query.startswith("REPLACE INTO"):   
      dbname_obj = re.search('(?<=REPLACE INTO `)([a-z_0-9]*)', query)
      dbname = dbname_obj.group(0)
      query_type = 'REPLACE'
    elif query.startswith("UPDATE "):   
      dbname_obj = re.search('(?<=UPDATE `)([a-z_0-9]*)', query)
      dbname = dbname_obj.group(0)
      query_type = 'UPDATE'  
    else:
      dbname = ''
      query_type = 'UNKNOWN'
  except Exception as e:
      dbname = 'unknown'
      query_type = 'UNKNOWN'
  #output_row_l.append(query_type)
  #output_row_l.append(dbname)
  print "{0} | {1}".format(query_type, dbname)
  df.loc[len(df)] = [query_type,dbname]

print "============================="
#print df
df_count = pd.DataFrame(df.groupby('dbname').size().rename('counts'))
df_count.to_csv('result.csv', sep=';')
print df_count


  
  
