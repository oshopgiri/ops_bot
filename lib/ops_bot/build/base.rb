# frozen_string_literal: true

class OpsBot::Build::Base
  def initialize
    @source_directory = OpsBot::Context.env.source.directory

    @name = OpsBot::Context.utils.build.name
    @path = OpsBot::Context.utils.build.path
    @s3_key = OpsBot::Context.utils.build.s3_key

    @s3_client = OpsBot::Integration::AWS::S3.new(bucket: OpsBot::Context.env.aws.s3.buckets.build)
  end

  def exists?(path: @path)
    return false unless path

    File.file?(path)
  end

  def package
    raise 'method definition missing!'
  end

  def delete_remote_branch_directory(key:)
    @s3_client.delete_directory(key:)
  end

  def s3_uri
    @s3_client.uri_for(key: @s3_key)
  end

  def upload
    return if uploaded?
    return unless exists?

    @s3_client.upload_file(key: @s3_key, file_path: @path)
  end

  def uploaded?
    @s3_client.file_exists?(key: @s3_key)
  end
end
