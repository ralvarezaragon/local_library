#!/usr/bin/python

import pymysql.cursors


def open_mysql_conn(conn_array):
    new_conn = pymysql.connect(
        host=conn_array["host"],
        user=conn_array["user"],
        passwd=conn_array["pwd"],
        db="mysql"
    )
    return new_conn


# Open connection
src_conn = open_mysql_conn(config["connections"][opt.target])

number_of_rows = cursor.executemany(sql, data)
db.commit()
# Clone schema
# Select the last id in src_table