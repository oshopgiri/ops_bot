# frozen_string_literal: true

class OpsBot::Job::Cleanup::OldS3Builds < OpsBot::Job::Base
  def self.perform
    s3_client = OpsBot::Integration::AWS::S3.new(bucket: OpsBot::Context.env.aws.s3.buckets.build)
    s3_client.delete_objects_older_than(time: OpsBot::Context.env.cleanup.s3_builds.older_than.days)

    true
  end
end
