#!/bin/bash

# S3

s3_check_build () {
  s3_url=$1

  existing_build=$(aws s3 ls $s3_url)
  [ -z "$existing_build" ] && exists=false || exists=true

  echo $exists
}

s3_download_build() {
  s3_url=$1
  path=$2

  aws s3 cp $s3_url $path --no-progress
}

s3_upload_build () {
  file_path=$1
  s3_url=$2

  aws s3 cp $file_path $s3_url --no-progress
}

# EBS

ebs_check_application_version () {
  application_name=$1
  version_label=$2

  existing_version=$(
    aws elasticbeanstalk describe-application-versions \
    --application-name "$application_name" \
    --version-labels "$version_label" \
    | grep -o '"VersionLabel": "[^"]*'
  )
  [ -z "$existing_version" ] && exists=false || exists=true

  echo $exists
}

ebs_create_application_version () {
  application_name=$1
  s3_bucket_name=$2
  s3_key=$3
  version_label=$4

  aws elasticbeanstalk create-application-version \
    --application-name "$application_name" \
    --source-bundle S3Bucket=$s3_bucket_name,S3Key=$s3_key \
    --version-label "$version_label"
}

ebs_deploy_application_version () {
  environment_name=$1
  version_label=$2

  aws elasticbeanstalk update-environment \
    --environment-name $environment_name \
    --version-label "$version_label"
}

# EC2 Security Group
ec2_sg_whitelist_ip () {
  security_group_id=$1
  protocol=$2
  ip_address=$3
  port=$4
  description=$5

  security_group_rule_id=$( \
    aws ec2 authorize-security-group-ingress \
      --group-id $security_group_id \
      --ip-permissions IpProtocol=$protocol,FromPort=$port,ToPort=$port,IpRanges=\[\{CidrIp=$ip_address/32,Description=$description\}\] \
    | jq -r ".SecurityGroupRules[0].SecurityGroupRuleId" \
  )

  echo $security_group_rule_id
}

ec2_sg_revoke_ip () {
  security_group_id=$1
  security_group_rule_id=$2

  status=$( \
    aws ec2 revoke-security-group-ingress \
      --group-id $security_group_id \
      --security-group-rule-ids $security_group_rule_id \
    | jq -r ".Return" \
  )

  echo $status
}
