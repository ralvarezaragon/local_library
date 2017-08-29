#!/usr/bin/python
import MySQLdb
import json
import logging, datetime, sys
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
    '--cluster', metavar='c', dest='cluster', type=str, choices=["hopper", "stats", "frank", "fargo"],
    help="Select the target cluster [hopper|stats|frank|fargo]"
  )
  parser.add_argument(
    '--option', metavar='o', dest='dbname', type=str, choices=["diff", "show", "add", "remove", "flush"],
    help="Choose betwen the option [diff|show|add|remove|flush]"
  )  
  args = parser.parse_args()
  return args


def exception_handler(error, q):  
  logging.error("%s", error)  
  if q == 'y':
    sys.exit()
    
    
def get_user_list(c):
  conn = open_mysql_conn(c)
  cur = conn.cursor()
  cur.execute("""SELECT concat(u.user, '@', u.host) as 'full_user', GROUP_CONCAT(privilege_type SEPARATOR ', ') as 'privileges', max(is_grantable) as 'grant'
              FROM mysql.user u
              LEFT JOIN information_schema.user_privileges up ON concat(u.user, '@', u.host) = replace(up.grantee, \"'\", \"\")
              GROUP BY user, host\G
  """)
  res = cur.fetch()
  conn.close()
  return res

today = datetime.date.today()
logging.basicConfig(
  format="%(asctime)s::%(filename)s::%(levelname)s::%(message)s",
  filename=today.strftime("/var/log/dbatools_%y%m%d.log"),
  level=logging.INFO
)
console = logging.StreamHandler()
console.setLevel(logging.INFO)

if __name__ == '__main__':
  # Load the menu
  try:
    opt = option_menu()
  except Exception as e:     
    exception_handler(e, 'y')
  # Get the list of mysql users with privileges
  try:
    get_user_list(config["connections"][opt.cluster])
  except Exception as e:     
    exception_handler(e, 'y')  