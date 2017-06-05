#!/usr/bin/env bash

for file in /tmp/output/*; do
  echo "Importing ${file} ..."
  time mysql esme_mesh_tracking < $file  
  rm $file
  sleep 10s;
  echo "done!"
done  