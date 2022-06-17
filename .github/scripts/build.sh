#!/bin/bash
source $REMOTE_SCRIPT_DIRECTORY/helpers.sh

s3_build_url=$S3_BUILD_DIRECTORY$TARGET_BUILD
build_exists=$(s3_check_build $s3_build_url)

if $build_exists
then
  echo "Existing build found on S3: $s3_build_url, skipping..."
else
  echo "Building..."
  build $BUILD_TYPE $TARGET_BUILD

  echo "Uploading build to S3..."
  s3_upload_build $BUILD_DIRECTORY/$TARGET_BUILD $S3_BUILD_DIRECTORY
  echo "Uploaded build to S3: $s3_build_url"
fi
