class OpsBot::Integration::AWS::S3
  def initialize
    @bucket = OpsBot::Context.env.aws.s3.bucket_name
    @key = OpsBot::Context.utils.build.s3_key
    @build_path = OpsBot::Context.utils.build.path
  end

  def build_exists?
    client.head_object(
      bucket: @bucket,
      key: @key
    )
    true
  rescue Aws::S3::Errors::NotFound
    false
  end

  def download_build
    resource
      .bucket(@bucket)
      .object(@key)
      .download_file(@build_path)
    true
  rescue Aws::S3::Errors::NotFound
    false
  end

  def upload_build
    resource
      .bucket(@bucket)
      .object(@key)
      .upload_file(@build_path)
  end

  private

    def client
      @client ||= Aws::S3::Client.new
    end

    def resource
      @resource = Aws::S3::Resource.new
    end
end
