class DeployActions::ENV::AWS
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
    "#{DeployActions::ENV::Base.normalized_application_name}/#{DeployActions::ENV::Base.normalized_branch_name}/#{DeployActions::ENV::Build.build_name}"
  end
end
