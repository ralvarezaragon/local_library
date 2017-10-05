#!/bin/bash

list_rds() {
	aws rds describe-db-instances --query "DBInstances[].[DBInstanceIdentifier]" --output text
}

list_s3() {
    aws s3 ls | awk '{print $3}'
}
declare -a tag_list=("Name" "area" "purpose" "dtap");

for tag in "${tag_list[@]}"; do
    echo "> INSTANCES MISSING TAG ${tag}"
    echo ">> EC2"
    aws ec2 describe-instances  --output text --query "Reservations[].Instances[?!not_null(Tags[?Key == '${tag}'].Value)] | [].[InstanceId]"
    echo ">> RDS"
    for id in $(list_rds); do
        resource="arn:aws:rds:eu-west-1:509579572466:db:$id"
	    rds_tag_list=$(aws rds list-tags-for-resource --resource-name "$resource" --query "TagList[]" --output text | awk '{print $1}' ORS=' ')
	    echo "${id} : ${rds_tag_list}" | grep -v "${tag}"
    done
    echo ">> S3"
    for id in $(list_s3); do
        s3_tag_list=$(aws s3api get-bucket-tagging --bucket ${id} --output text | awk '{print $2}' ORS=' ')
        echo "${id} : ${s3_tag_list}" | grep -v "${tag}"
    done
    echo ">> CloudFront"
    echo ">> WorkMail"
    echo ">> Data transfer"
done