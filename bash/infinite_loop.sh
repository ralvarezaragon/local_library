#!/bin/bash

while true; do
  time curl -X GET $1
  sleep $2
done