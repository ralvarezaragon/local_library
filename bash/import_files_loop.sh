#!/usr/bin/env bash
#./import_files_loop.sh -h 10.0.3.1 -d users_ralvarez -f output_test -s 2
while getopts h:d:f:s: opts; do
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
done

for file in /tmp/${folder}/*.sql; do
  echo "Importing ${file} ..."
  #time mysql -h ${host} ${dbname} < $file
  echo "mysqli -h ${host} ${dbname} < $file"
  #rm $file
  sleep ${sleep}s;
  echo "done!"
done  