#!/usr/bin/python
import MySQLdb
import json
import logging
import datetime
import sys
import argparse
import re

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
    '--cluster', metavar='c', dest='cluster', type=str, choices=["hopper", "stats", "frank", "hopperT"],
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
  conn = open_mysql_conn(c)
  cur = conn.cursor()
  cur.execute("SHOW CREATE TABLE {0}.{1}".format(db, t))
  res = cur.fetchone()
  conn.close()
  return res


def create_new_table(c, db, q):
  conn = open_mysql_conn(c)
  cur = conn.cursor()
  cur.execute("USE {0}".format(db))
  conn.commit()  
  cur.execute(q)
  conn.commit()
  conn.close()  


def get_row_count(c, db, t):
  conn = open_mysql_conn(c)
  cur = conn.cursor()
  cur.execute("SELECT table_rows FROM information_schema.TABLES WHERE table_schema = '{0}' and table_name = '{1}'".format(db, t))
  res = cur.fetchone()
  conn.close()
  return res


def get_col_list(c, db, t):
  conn = open_mysql_conn(c)
  cur = conn.cursor()
  cur.execute("SELECT column_name,column_default FROM information_schema.COLUMNS WHERE table_schema = '{0}' and table_name = '{1}'".format(db, t))
  res = cur.fetchall()  
  conn.close()
  return res


def insert_into_new_table(c, q):
  conn = open_mysql_conn(c)
  cur = conn.cursor()    
  cur.execute(q)
  conn.commit()
  conn.close() 


def rename_table(c, db, t1, t2):
  conn = open_mysql_conn(c)
  cur = conn.cursor()    
  cur.execute("RENAME TABLE {0}.{1} TO {0}.{2}".format(db, t1, t2))
  conn.commit()
  conn.close()
  

def modify_schema(t, sch):
    # Create new table name  
  new_tname = "TABLE `{0}_new`".format(t)
  new_schema = re.sub(r'TABLE `\w+`', new_tname, sch)
  # Remove columns
  remove_col_syntax = ""
  for new_col in syntax["remove"]:
    remove_col_syntax = "\\n  {0},".format(new_col)
    remove_col_syntax = remove_col_syntax.replace("(", "\(")
    remove_col_syntax = remove_col_syntax.replace(")", "\)")
    new_schema = re.sub(remove_col_syntax, "", new_schema)  
  # Add columns
  new_col_syntax = ""  
  for new_col in syntax["add"]:
    new_col_syntax += "\n  {0},".format(new_col)    
  new_syntax = "{0}\\n  PRIMARY KEY".format(new_col_syntax)
  new_schema = re.sub(r'\n  PRIMARY KEY', new_syntax, new_schema)
  # Change columns
  for new_col in syntax["change"]:
    change_col_syntax = "  {0},".format(new_col)    
    pattern_to_change_obj = re.search(r'`\w+`', change_col_syntax)
    pattern_to_change = "  {0}[\w+()'', ]*".format(pattern_to_change_obj.group(0))
    new_schema = re.sub(pattern_to_change, change_col_syntax, new_schema)
  return new_schema  


def ask_to_continue():
  keep_going = raw_input("Do you want to continue? ")
  keep_going = str(keep_going).lower()
  while keep_going not in ['y', 'n']: 
    print("Just Y or N please")
    keep_going = raw_input("Do you want to continue? ")
    keep_going = str(keep_going).lower()
  if keep_going == 'y':
    logging.info("User accept to continue")        
  elif keep_going == 'n':
    logging.info("User decline to continue")  
    print ("Process aborted by the user")
    sys.exit()    
    

def build_insert_query(db, t, new_t):  
  l = []  
  q = "INSERT INTO {0}.{1} SELECT ".format(db, new_t)
  for col in ori_col_res:
    l.append(col[0])    
  for col in new_col_res:    
    if col[0] not in l:
      q += "'{0}'".format(col[1])
    else:      
      q += "`{0}`".format(col[0])
  q += " FROM {0}.{1}".format(db, t)
  q = q.replace("``", "`, `")
  q = q.replace("`'", "`, '")
  q = q.replace("'`", "', `")
  q = q.replace("''", "', '")
  return q
    
    
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
try:
  syntax = parse_json('syntax.json')
except Exception as e:
    message = "Syntax file couldn't be loaded, Check the logs for details"
    exception_handler(e, message, 'y')

if __name__ == '__main__':
  try:
    opt = option_menu()
  except Exception as e:
    message = "Something in the input parameters went wrong. Process aborted Check the logs for details"
    exception_handler(e, message, 'y')
  # First of all check how big is the damnd table      
  row_count = get_row_count(config["connections"][opt.cluster], opt.dbname, opt.tname)
  logging.info("Table to alter contains %s records (estimated)", row_count[0])
  print ("The table you want to alter contains {0} records (estimated)".format(row_count[0]))
  ask_to_continue()  
  # Get the original schema  
  out = get_table_schema(config["connections"][opt.cluster], opt.dbname, opt.tname)  
  print ("ORIGINAL SCHEMA -> {0}".format(out[1]))
  logging.info("ORIGINAL SCHEMA::%s", out[1])  
  print "======================================"
  try:
    new_schema = modify_schema(opt.tname,out[1])    
    print ("NEW SCHEMA -> {0}".format(new_schema))
    logging.info("NEW SCHEMA::%s", new_schema)
  except Exception as e:
    message = "Modification of current schema to buil up new one failed. Process aborted. Check the logs for details"
    exception_handler(e, message, 'y')
  # wait for user's input before continue  
  ask_to_continue()
  # Create the new table with the modified schema  
  try:    
    create_new_table(config["connections"][opt.cluster], opt.dbname, new_schema)
    message = "New table created"
    logging.info(message)
    print(message)
  except Exception as e:
    message = "Creation of new table failed. Process aborted. Check the logs for details"
    exception_handler(e, message, 'y')
    print(message)
    
  # INSERT PROCCESS
  # Get original column list
  try:
    new_tname = "{0}_new".format(opt.tname)
    ori_col_res = get_col_list(config["connections"][opt.cluster], opt.dbname, opt.tname)    
    new_col_res = get_col_list(config["connections"][opt.cluster], opt.dbname, new_tname)
    insert_query = build_insert_query(opt.dbname, opt.tname, new_tname)    
    logging.info(insert_query)
    print(insert_query)
  except Exception as e:
    message = "Something went wrong building the INSERT query. Process aborted. Check the logs for details"
    exception_handler(e, message, 'y')
  # Do the the insert  
  try:
    insert_into_new_table(config["connections"][opt.cluster], insert_query)
    message = "INSERT operation done"
    logging.info(message)
    print(message)
  except Exception as e:
    message = "INSERT FAILED. Process aborted. Check the logs for details"
    exception_handler(e, message, 'y')
    print(message)
  
  # RENAME TABLES
  new_tname = "{0}_new".format(opt.tname)
  old_tname = "{0}_old".format(opt.tname)
  rename_table(config["connections"][opt.cluster], opt.dbname, opt.tname, old_tname)
  rename_table(config["connections"][opt.cluster], opt.dbname, new_tname, opt.tname)
      

  
