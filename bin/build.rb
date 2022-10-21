require_relative '../config/boot.rb'

s3_build_url = "s3://#{DeployActions::Utils.s3_bucket_name}/#{DeployActions::Utils.s3_build_key}"
s3_client = DeployActions::AWS::S3.new

if s3_client.build_exists?
  puts "Existing build found on S3: #{s3_build_url}"
else
  build_client = DeployActions::Build.new

  puts 'Building...'
  build_client.build

  unless build_client.build_exists?
    puts 'Build failed. Check logs for errors.'
    exit(1)
  end

  puts 'Uploading build to S3...'
  s3_client.upload_build

  if s3_client.build_exists?
    puts "Uploaded build to S3: #{s3_build_url}"
  else
    puts 'Uploading build failed. Check logs for errors.'
    exit(1)
  end
end

exit(0)
