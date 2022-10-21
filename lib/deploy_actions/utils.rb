class DeployActions::Utils
  def self.normalized_branch_name
    branch_name.titleize.parameterize
  end

  def self.normalized_application_name
    ebs_application_name&.parameterize
  end

  def self.parsed_serviced_repos
    ENV['SERVICED_REPOS'].split(';').map(&:strip)
  end

  # GitHub

  def self.action_name
    ENV['GITHUB_ACTION_NAME']
  end

  def self.action_run_attempt
    ENV['GITHUB_RUN_ATTEMPT']
  end

  def self.action_run_id
    ENV['GITHUB_RUN_ID']
  end

  def self.action_run_number
    ENV['GITHUB_RUN_NUMBER']
  end

  def self.action_run_suffix
    "##{action_run_number}_#{action_run_attempt}"
  end

  def self.action_run_url
    "https://github.com/#{ENV['GITHUB_REPOSITORY']}/actions/runs/#{action_run_id}/attempts/#{action_run_attempt}"
  end

  def self.actor
    ENV['GITHUB_ACTOR']
  end

  def self.actor_url
    "https://github.com/#{actor}"
  end

  def self.branch_name
    ENV['GITHUB_REF_NAME']
  end

  def self.branch_url
    "https://github.com/#{repository_name}/tree/#{branch_name}"
  end

  def self.commit_reference
    ENV['GITHUB_SHA']
  end

  def self.commit_url
    "https://github.com/#{repository_name}/commit/#{commit_reference}"
  end

  def self.repository_name
    ENV['GITHUB_REPOSITORY']
  end

  # AWS

  def self.aws_region
    ENV['AWS_REGION']
  end

  def self.access_key_id
    ENV['AWS_ACCESS_KEY_ID']
  end

  def self.ebs_application_name
    ENV['AWS_EBS_APPLICATION_NAME']
  end

  def self.ebs_application_url
    "https://#{aws_region}.console.aws.amazon.com/elasticbeanstalk/home?region=#{aws_region}#/application/overview?applicationName=#{ebs_application_name}"
  end

  def self.ebs_environment_name
    ENV['AWS_EBS_ENVIRONMENT_NAME']
  end

  def self.ebs_environment_url
    environment_details = begin
      ebs_client = DeployActions::AWS::EBS.new
      ebs_client.describe_environment
    rescue
      nil
    end

    environment_details.present? ?
      "https://#{aws_region}.console.aws.amazon.com/elasticbeanstalk/home?region=#{aws_region}#/environment/dashboard?applicationName=#{ebs_application_name}&environmentId=#{environment_details.environment_id}" :
      ebs_application_url
  end

  def self.ebs_instance_type
    ENV['AWS_EBS_INSTANCE_TYPE']
  end

  def self.ec2_security_group_id
    ENV['AWS_EC2_SECURITY_GROUP_ID']
  end

  def self.ec2_security_group_rule_description
    "github-#{actor}"
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

  # Slack

  def self.slack_channel_ids
    ENV['SLACK_CHANNEL_IDS']
  end

  # Build

  def self.build_name
    "ref-#{commit_reference}.#{build_type}"
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
    "ver-#{commit_reference}"
  end

  # Log

  def self.log_file_path
    ENV['LOG_FILE_PATH']
  end

  # Source

  def self.source_directory
    ENV['SOURCE_DIRECTORY']
  end

  # Action

  def self.action_environment
    ENV['ACTION_ENVIRONMENT'].to_s.underscore
  end

  def self.is_production_action?
    action_environment.casecmp? 'production'
  end
end
