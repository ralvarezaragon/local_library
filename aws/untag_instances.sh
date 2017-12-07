#!/bin/bash

list_rds() {
	aws rds describe-db-instances --query "DBInstances[].[DBInstanceArn]" --output text
}

list_s3() {
    aws s3 ls | awk '{print $3}'
}

list_cloudfront() {
    aws cloudfront list-distributions --query 'DistributionList.Items[].ARN' --output text
}

declare -a tag_list=("Name" "area" "purpose" "dtap" "unit");

for tag in "${tag_list[@]}"; do
    echo -e "\e[1;93mMISSING TAG: \e[1;31m${tag}\e[0m"
    echo -e "\e[1;93mEC2\e[0m"
    aws ec2 describe-instances  --output text --query "Reservations[].Instances[?!not_null(Tags[?Key == '${tag}'].Value)] | [].[InstanceId]"
    echo -e "\e[1;93mRDS\e[0m"
    for arn in $(list_rds); do
        rds_tag_list=$(aws rds list-tags-for-resource --resource-name "$arn" --query "TagList[]" --output text | awk '{print $1}' ORS=' ')
        echo "${arn} : ${rds_tag_list}\n" | grep -v "${tag}" | awk '{print $1}'
    done
    echo -e "\e[1;93mS3\e[0m"
    for id in $(list_s3); do
        s3_tag_list=$(aws s3api get-bucket-tagging --bucket ${id} --output text | awk '{print $2}' ORS=' ')
        echo "${id} : ${s3_tag_list}\n" | grep -v "${tag}" |  awk '{print $1}'
    done
    echo -e "\e[1;93mCloudFront\e[0m"
    for arn in $(list_cloudfront); do
        cloudfront_tag_list=$(aws cloudfront list-tags-for-resource --resource "$arn" --output text | awk '{print $2}' ORS=' ')
        echo "${arn} : ${cloudfront_tag_list}" | grep -v "${tag}" | awk '{print $1}'
    done
done

