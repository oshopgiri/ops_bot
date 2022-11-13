class OpsBot::Job::Build < OpsBot::Job::Base
  def self.perform
    s3_build_url = "s3://#{OpsBot::Context.env.aws.s3.bucket_name}/#{OpsBot::Context.utils.build.s3_key}"
    s3_client = OpsBot::Integration::AWS::S3.new

    if s3_client.build_exists?
      puts "Existing build found on S3: #{s3_build_url}"
    else
      build_client = OpsBot::Build.new

      puts 'Building...'
      build_client.package

      unless build_client.build_exists?
        puts 'Build failed. Check logs for errors.'
        return false
      end

      puts 'Uploading build to S3...'
      s3_client.upload_build

      if s3_client.build_exists?
        puts "Uploaded build to S3: #{s3_build_url}"
      else
        puts 'Uploading build failed. Check logs for errors.'
        return false
      end
    end

    true
  end
end
