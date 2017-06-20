#!/usr/bin/env bash

case ${opts} in
  h)
    host=${OPTARG};;
  d)
    dbname=${OPTARG};;
  f)
    folder=${OPTARG};;
esac

for file in /tmp/${folder}/*.sql; do
  echo "Importing ${file} ..."
  #time mysql -h ${host} ${dbname} < $file
  echo "mysqli -h ${host} ${dbname} < $file"
  #rm $file
  sleep 10s;
  echo "done!"
done  