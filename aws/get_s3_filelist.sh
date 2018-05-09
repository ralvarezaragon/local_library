#!/bin/bash

# configure AWS CLI (e.g. use IAM role for S3 access)
export AWS_DEFAULT_REGION=eu-west-1
export AWS_ACCESS_KEY_ID=AKIAJUY7O52RDKNVXOPQ
export AWS_SECRET_ACCESS_KEY=EBUO3bJ/3HgpSnlKa/j2y+3s2PoMgyXYNuVhzMIh

# file list as an array
flist=(`aws s3 ls s3://basebone.datalake/0_landing_area/ | awk '{print $4}'`)

# all elements
echo ${flist[@]}
