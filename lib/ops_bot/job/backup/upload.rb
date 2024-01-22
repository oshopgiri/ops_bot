class OpsBot::Job::Backup::Upload < OpsBot::Job::Base
  def self.perform
    @s3_client = OpsBot::Integration::AWS::S3.new(bucket: OpsBot::Context.env.aws.s3.buckets.backup)
    @s3_client.upload_file(
      key: OpsBot::Context.utils.backup.s3_key,
      file_path: OpsBot::Context.utils.backup.path
    )

    true
  end
end
