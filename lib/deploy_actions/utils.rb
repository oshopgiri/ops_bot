class DeployActions::Utils
  def self.normalized_branch_name
    ENV['GITHUB_REF_NAME'].titleize.parameterize
  end

  def self.normalized_application_name
    ebs_application_name&.parameterize
  end

  def self.parsed_serviced_repos
    ENV['SERVICED_REPOS'].split(';').map(&:strip)
  end

  # AWS

  def self.access_key_id
    ENV['AWS_ACCESS_KEY_ID']
  end

  def self.ebs_application_name
    ENV['AWS_EBS_APPLICATION_NAME']
  end

  def self.ebs_environment_name
    ENV['AWS_EBS_ENVIRONMENT_NAME']
  end

  def self.ebs_instance_type
    ENV['AWS_EBS_INSTANCE_TYPE']
  end

  def self.ec2_security_group_id
    ENV['AWS_EC2_SECURITY_GROUP_ID']
  end

  def self.ec2_security_group_rule_description
    "github-#{ENV['GITHUB_ACTOR']}"
  end

  def self.ec2_security_group_rule_ip_address
    ENV['AWS_EC2_SGR_IP_ADDRESS'].to_s
  end

  def self.ec2_security_group_rule_port
    ENV['AWS_EC2_SGR_PORT']
  end

  def self.ec2_security_group_rule_protocol
    ENV['AWS_EC2_SGR_PROTOCOL']
  end

  def self.iam_user_name
    ENV['AWS_IAM_USER_NAME']
  end

  def self.s3_bucket_name
    ENV['AWS_S3_BUCKET_NAME']
  end

  def self.s3_build_key
    "#{normalized_application_name}/#{normalized_branch_name}/#{build_name}"
  end

  # Build

  def self.build_name
    "ref-#{ENV['GITHUB_SHA']}.#{build_type}"
  end

  def self.build_directory
    ENV['BUILD_DIRECTORY']
  end

  def self.build_path
    "#{build_directory}/#{build_name}"
  end

  def self.build_type
    ENV['BUILD_TYPE']
  end

  def self.build_version
    "ver-#{ENV['GITHUB_SHA']}"
  end

  # Log

  def self.log_file_path
    ENV['LOG_FILE_PATH']
  end

  # Source

  def self.source_directory
    ENV['SOURCE_DIRECTORY']
  end
end
