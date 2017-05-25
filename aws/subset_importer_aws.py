#!/usr/bin/python

# This script export the last 100 records for each table from our prod environment
# and import it to AWS test environment
# Syntax example: python subset_importer_aws.py --schema=n --dblist=frank --source=frank --target=frankT

import pymysql.cursors
import json
import os
import shutil
import argparse
import logging
import glob
import datetime
import sys


def parse_json(config_file):
    with open(config_file) as json_data:
        output = json.load(json_data)
    return output


def option_menu():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '--schema', metavar='s', dest='schema', type=str, choices=["y", "n"],
        help="Specify if the importer will create the schema from scratch or it's already there"
    )
    parser.add_argument(
        '--dblist', metavar='d', dest='dblist', type=str, choices=["hopper", "stats", "product", "frank"],
        help="Send a list with all the databases that needs to export data from"
    )
    parser.add_argument(
        '--source', metavar='c', dest='source', type=str, choices=["hopper", "stats", "frank"],
        help="Declare the source host which export the sample data"
    )
    parser.add_argument(
        '--target', metavar='t', dest='target', type=str, choices=["hopperT", "statsT", "productT", "frankT"],
        help="Declare the target host which receive the sample data"
    )
    args = parser.parse_args()
    return args


def prepare_sql_files(d):
    source_dir = d["source"]
    target_dir = d["target"]
    if os.path.exists(target_dir):
        shutil.rmtree(target_dir)
    shutil.copytree(source_dir, target_dir)
    os.system("gunzip -d {0}/*".format(target_dir))


def open_mysql_conn(conn_array):
    new_conn = pymysql.connect(
        host=conn_array["host"],
        user=conn_array["user"],
        passwd=conn_array["pwd"],
        db="mysql"
    )
    return new_conn


def create_db(conn, db):
    cur = conn.cursor()
    cur.execute("SELECT COUNT(*) FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = '{0}'".format(db))
    res = cur.fetchone()
    row_number = res[0]
    if row_number == 0:
        cur.execute("CREATE DATABASE IF NOT EXISTS {0}".format(db))
        logging.info("db %s created", db)
    else:
        logging.info("db %s already exists. Creation skipped", db)


def get_table_list(conn):
    cur = conn.cursor()
    cur.execute("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '{0}'".format(db))
    res = cur.fetchall()
    return res


def import_sql_file(conn_array, dbname, sql_file):
    cmd = "mysql -h {0} -u {1} -p{2} {3} < {4}".format(
        conn_array["host"],
        conn_array["user"],
        conn_array["pwd"],
        dbname,
        sql_file
    )
    return cmd


def export_subset(create_flag, conn_array, dbname, tname, limit, sql_file):
    if (create_flag == "n"):
        create_option = "--no-create-info"
    else:
        create_option = ""

    cmd = 'mysqldump -h {0} -u {1} -p{2} {3} {4} {5} --single-transaction --quick --lock-tables=false --insert-ignore --where="1=1 order by 1 desc limit {6}" > "{7}"'.format(
        conn_array["host"],
        conn_array["user"],
        conn_array["pwd"],        
        dbname,
        tname,
        create_option,
        limit,
        sql_file
    )
    return cmd


def run_command(cmd):
    os.system(cmd)
    logging.debug(cmd)


def exception_handler(error, msg, q, conn):
    logging.error(msg)
    logging.error("%s", error)
    if str(q) in locals():
        q.close()
    if q == 'y':
        sys.exit()


def get_total_table_count(conn):
    cur = conn.cursor()
    cur.execute(
        "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA not in ('mysql', 'information_schema', 'performance_schema')")
    result = cur.fetchone()
    total_table_count = result[0]
    return total_table_count

today = datetime.date.today()
logging.basicConfig(
    format="%(asctime)s::%(levelname)s::%(message)s",
    filename=today.strftime("/var/log/aws_importer_%y%m%d.log"),
    level=logging.DEBUG
)
config = parse_json('config.json')
os.chdir(config["folders"]["target"])

if __name__ == '__main__':
    try:
        opt = option_menu()
    except Exception as e:
        message = "Something in the input parameters went wrong. Process aborted"
        exception_handler(e, message, 'y', 'na')      

    # Export dump files with sample of data from source host
    # Get the total list of table in order to make a progress counter
    table_count = 0
    target_conn = open_mysql_conn(config["connections"][opt.target])
    total_table_count = get_total_table_count(target_conn)
    target_conn.close()
    for db in config["db_list"][opt.dblist]:
        try:
             # Create the db in target, if not exists
            target_conn = open_mysql_conn(config["connections"][opt.target])             
            create_db(target_conn, db)
            target_conn.close()
            # Read table names from source host
            source_conn = open_mysql_conn(config["connections"][opt.source])
            result = get_table_list(source_conn)
            source_conn.close()
            for tname in result:
                try:                   
                    # Define sample sql dump file
                    output_file = "{0}subset.{1}.{2}.sql".format(config["folders"]["target"], db, tname[0])
                    # Run mysqldump to get the sample files
                    command = export_subset(opt.schema, config["connections"][opt.source], db, tname[0], config["limit"], output_file)
                    run_command(command)
                    logging.info("%s file created", output_file)
                    # Import the files into the target host
                    command = import_sql_file(config["connections"][opt.target], db, output_file)
                    run_command(command)
                    logging.info("%s imported into target host", output_file)
                except Exception as e:
                    message = "The import process failed with the following error"
                    exception_handler(e, message, 'n', 'na')
                finally:
                    print("{0}/{1}".format(table_count, total_table_count))
                    table_count += 1

        except Exception as e:
            message = "Getting the tables from the DB list failed"
            exception_handler(e, message, 'n', 'target_conn')




