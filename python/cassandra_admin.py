from cassandra.cluster import Cluster
import uuid
import csv
import re
import sys

cluster = Cluster(['5.40.33.9'], port=16014)
session = cluster.connect()

session.set_keyspace('testks')
#session.execute('USE users')

csv.field_size_limit(sys.maxsize)
input_l = list(csv.reader(open('query_10_30.log', 'rb'), delimiter='\t'))

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
      query = ''
      dbname = ''
      query_type = 'UNKNOWN'

  query = query.replace("'", '"')
  guid = uuid.uuid4()
  sql = """
    INSERT INTO query_log (guid, dbname, query, query_type)
    VALUES ('{0}', '{1}', '{2}', '{3}')""".format(guid, dbname, query, query_type)
  print query
  session.execute(sql)

