#!/bin/bash

slackhost=basebone
channel=dba-utils
webhook_url=https://hooks.slack.com/services/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

list_rds() {
	aws rds describe-db-instances --query "DBInstances[].[DBInstanceArn]" --output text
}

list_s3() {
    aws s3 ls | awk '{print $3}'
}

list_cloudfront() {
    aws cloudfront list-distributions --query 'DistributionList.Items[].ARN' --output text
}

declare -a tag_list=("Name" "area" "purpose" "dtap");

output=$(
    for tag in "${tag_list[@]}"; do
        echo "*MISSING TAG: ${tag}*\n"
        echo "*EC2*\n"
        aws ec2 describe-instances  --output text --query "Reservations[].Instances[?!not_null(Tags[?Key == '${tag}'].Value)] | [].[InstanceId]"
        echo "*RDS*\n"
        for arn in $(list_rds); do
            rds_tag_list=$(aws rds list-tags-for-resource --resource-name "$arn" --query "TagList[]" --output text | awk '{print $1}' ORS=' ')
            echo "${arn} : ${rds_tag_list}\n" | grep -v "${tag}" | awk '{print $1}' | sed 's/$/\\n/g'
        done
        echo "*S3*\n"
        for id in $(list_s3); do
            s3_tag_list=$(aws s3api get-bucket-tagging --bucket ${id} --output text | awk '{print $2}' ORS=' ')
            echo "${id} : ${s3_tag_list}\n" | grep -v "${tag}" |  awk '{print $1}' | sed 's/$/\\n/g'
        done
        echo "*CloudFront*\n"
        for arn in $(list_cloudfront); do
            cloudfront_tag_list=$(aws cloudfront list-tags-for-resource --resource "$arn" --output text | awk '{print $2}' ORS=' ')
            echo "${arn} : ${cloudfront_tag_list}" | grep -v "${tag}" | awk '{print $1}' | sed 's/$/\\n/g'
        done
    done
)

escapedText=$(echo $output | sed 's/"/\"/g' | sed "s/'/\'/g" )
json="{\"channel\": \"$channel\", \"text\": \"$escapedText\"}"

curl -s -d "payload=$json" "$webhook_url" 2>&1 > /dev/null;