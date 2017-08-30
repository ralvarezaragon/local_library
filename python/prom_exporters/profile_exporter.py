#!/usr/bin/python

import subprocess as sub
import re

def get_insert_row(row):
  row_substr = re.search('(INSERT INTO `)([a-z_0-9]*)`.`([a-z_0-9]*)', row)
  query['dbname'] = row_substr.group(2)
  query['tname'] = row_substr.group(3)
  query['type'] = 'INSERT'
  return query


def get_select_row(row):
  row_substr = re.search('SELECT .* FROM `([a-z_0-9]*)`.`([a-z_0-9]*)', row)
  query['dbname'] = row_substr.group(1)
  query['tname'] = row_substr.group(2)
  query['type'] = 'SELECT'
  return query


def get_update_row(row):
  row_substr = re.search('(UPDATE )([a-z_0-9]*)`.`([a-z_0-9]*)(` SET )', row)
  query['dbname'] = row_substr.group(2)
  query['tname'] = row_substr.group(3)
  query['type'] = 'SELECT'
  return query


p = sub.Popen(('sudo', 'tcpdump', '-i', 'eno2', '-s', '0', '-l', '-w', '-', 'dst', 'port 3306'), stdout=sub.PIPE)
for row in iter(p.stdout.readline, b''):
  query = dict()
  if row.find('INSERT') > -1:    
    print get_insert_row(row)
  elif row.find('SELECT ') > -1 and row.find(' FROM') > -1:
    print get_select_row(row)
  elif row.find('UPDATE') > -1 and row.find('SET') > -1:
    print get_update_row(row) 
