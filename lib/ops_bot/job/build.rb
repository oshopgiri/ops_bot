# frozen_string_literal: true

class OpsBot::Job::Build < OpsBot::Job::Base
  def self.perform
    build_client = OpsBot::Build.new

    if build_client.uploaded?
      Application.logger.info("Existing build found on S3: #{build_client.s3_uri}")
    else
      build_client.package

      unless build_client.exists?
        Application.logger.error('Build failed. Check logs for errors.')
        return false
      end

      build_client.upload

      if build_client.uploaded?
        Application.logger.info("Uploaded build to S3: #{build_client.s3_uri}")
      else
        Application.logger.error('Uploading build failed. Check logs for errors.')
        return false
      end
    end

    true
  end
end
