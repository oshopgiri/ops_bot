# frozen_string_literal: true

class OpsBot::Job::Cleanup::OldS3Builds < OpsBot::Job::Base
  def self.perform
    ebs_client = OpsBot::Integration::AWS::EBS.new
    build_hashes = ebs_client.describe_environments.map { |environment| environment.version_label.gsub('ver-', '') }

    older_than = OpsBot::Context.env.cleanup.s3_builds.older_than
    s3_client = OpsBot::Integration::AWS::S3.new(bucket: OpsBot::Context.env.aws.s3.buckets.build)
    builds_deleted = s3_client.delete_objects_older_than(
      filter: { excludes: build_hashes },
      time: older_than.days
    )

    Application.logger.info("Cleaned-up #{builds_deleted} builds older than #{older_than} days...")

    true
  end
end
