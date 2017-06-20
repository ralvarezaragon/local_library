#!/usr/bin/env bash
#./import_files_loop.sh -h 10.0.3.1 -d esme_mesh_tracking -f output_in -s 2
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
  time mysql -h ${host} ${dbname} < $file  
  mv "${file}" "${file}.imp"
  sleep ${sleep}s;
  echo "done!"
done  