#!/usr/bin/env bash

case ${opts} in
  h)
    host=${OPTARG};;
  d)
    dbname=${OPTARG};;
  f)
    folder=${OPTARG};;
  s)
    sleep=${OPTARG};
esac

for file in /tmp/${folder}/*.sql; do
  echo "Importing ${file} ..."
  #time mysql -h ${host} ${dbname} < $file
  echo "mysqli -h ${host} ${dbname} < $file"
  #rm $file
  #sleep ${sleep}s;
  echo "done!"
done  