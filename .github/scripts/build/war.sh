#!/bin/bash
source ./.github/scripts/helpers.sh

s3_build_url=$S3_BUILD_DIRECTORY$TARGET_BUILD
build_exists=$(s3_check_build $s3_build_url)

if $build_exists
then
  echo "Existing build found on S3: $s3_build_url, skipping..."
else
  echo "Building war file..."
  build_war $TARGET_BUILD

  echo "Uploading war file to S3..."
  s3_upload_build ./target/$TARGET_BUILD $S3_BUILD_DIRECTORY
  echo "Uploaded war file to S3: $s3_build_url"
fi
