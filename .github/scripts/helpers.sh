#!/bin/bash

# Build

build () {
  type=$1
  name=$2

  mkdir build

  case $type in
    war)
      __build_war $name
      ;;
    zip)
      __build_zip $name
      ;;
  esac
}

__build_war () {
  name=$1

  mvn package -q -f pom.xml
  mv $(ls ./target/*.war | head -1) ./build/$name
}

__build_zip () {
  name=$1

  zip ./build/$name -qr * .[^.]*
}

# S3

s3_check_build () {
  s3_url=$1

  existing_build=$(aws s3 ls $s3_url)
  [ -z "$existing_build" ] && exists=false || exists=true

  echo $exists
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
