class OpsBot::Job::Build < OpsBot::Job::Base
  def self.perform
    s3_client = OpsBot::Integration::AWS::S3.new

    if s3_client.build_exists?
      $logger.info("Existing build found on S3: #{s3_client.build_url}")
    else
      build_client = OpsBot::Build.new

      build_client.package

      unless build_client.build_exists?
        $logger.error('Build failed. Check logs for errors.')
        return false
      end

      s3_client.upload_build

      if s3_client.build_exists?
        $logger.info("Uploaded build to S3: #{s3_client.build_url}")
      else
        $logger.error('Uploading build failed. Check logs for errors.')
        return false
      end
    end

    true
  end
end
