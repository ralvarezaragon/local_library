#!/usr/bin/python
import MySQLdb
import json
import logging
import datetime
import sys
import argparse


def parse_json(config_file):
  with open(config_file) as json_data:
    output = json.load(json_data)
  return output


def open_mysql_conn(conn_array):
  new_conn = MySQLdb.connect(
    host=conn_array["host"],
    user=conn_array["user"],
    passwd=conn_array["pwd"],
    db="mysql"
  )
  return new_conn


def option_menu():
  parser = argparse.ArgumentParser()
  parser.add_argument(
    '--cluster', metavar='c', dest='cluster', type=str, choices=["hopper", "stats", "frank"],
    help="Select the target cluster [hopper|stats|frank]"
  )
  parser.add_argument(
    '--db', metavar='d', dest='dbname', type=str, 
    help="Declare the target database"
  )
  parser.add_argument(
    '--table', metavar='t', dest='tname', type=str, 
    help="Declare the target table"
  ) 
  args = parser.parse_args()
  return args


def exception_handler(error, msg, q):
  logging.error(msg)
  logging.error("%s", error)  
  if q == 'y':
    sys.exit()
        

def get_table_schema(c, db, t):
  cur = c.cursor()
  cur.execute("SHOW CREATE TABLE {0}.{1}".format(db, t))
  res = cur.fetchone()
  c.close()
  return res

today = datetime.date.today()
logging.basicConfig(
  format="%(asctime)s::%(levelname)s::%(message)s",
  filename=today.strftime("/var/log/alter_table_%y%m%d.log"),
  level=logging.INFO
)
try:
  config = parse_json('config.json')
except Exception as e:
    message = "Config file couldn't be loaded, Check the logs for details"
    exception_handler(e, message, 'y')


if __name__ == '__main__':
  try:
    opt = option_menu()
  except Exception as e:
    message = "Something in the input parameters went wrong. Process aborted"
    exception_handler(e, message, 'y') 

  cluster_name = "{0}_admin".format(opt.cluster)
  conn = open_mysql_conn(config["connections"][cluster_name])
  out = get_table_schema(conn, opt.dbname, opt.tname)
  print (out)
# print all the first cell of all the rows
#for row in cur.fetchall():
#    print row[0]


  
# * create new schema from SHOW CREATE TABLE
# * add changes
# * execute
# * move data
# * rename current to old
# * rename new to current