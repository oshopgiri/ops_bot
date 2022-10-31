class DeployActions::Utils
  def self.normalized_branch_name
    # GITHUB_REF_NAME
    branch_name.titleize.parameterize
  end

  def self.normalized_application_name
    # AWS_EBS_APPLICATION_NAME
    ebs_application_name&.parameterize
  end

  def self.parsed_serviced_repos
    ENV['ACCESS_KEY_SERVICED_REPOS'].split(';').map(&:strip)
  end

  def self.build_name
    # GITHUB_SHA
    # BUILD_TYPE
    "ref-#{commit_reference}.#{build_type}"
  end

  def self.build_path
    # BUILD_DIRECTORY
    "#{build_directory}/#{build_name}"
  end

  def self.build_version
    # GITHUB_SHA
    "ver-#{commit_reference}"
  end

  def self.ec2_security_group_rule_description
    # GITHUB_ACTOR
    "github-#{actor}"
  end

  def self.s3_build_key
    "#{normalized_application_name}/#{normalized_branch_name}/#{build_name}"
  end

  def self.action_run_url
    # GITHUB_REPOSITORY
    "https://github.com/#{repository_name}/actions/runs/#{ENV['GITHUB_RUN_ID']}/attempts/#{ENV['GITHUB_RUN_ATTEMPT']}"
  end

  def self.branch_url
    # GITHUB_REPOSITORY
    # GITHUB_REF_NAME
    "https://github.com/#{repository_name}/tree/#{branch_name}"
  end

  def self.commit_url
    # GITHUB_REPOSITORY
    # GITHUB_SHA
    "https://github.com/#{repository_name}/commit/#{commit_reference}"
  end

  def self.workflow_environment
    ENV['WORKFLOW_ENVIRONMENT'].to_s.underscore
  end

  def self.is_production_deploy?
    workflow_environment.casecmp? 'production'
  end

  # -----------------------------------------------------------------

  def self.actor_url
    "https://github.com/#{actor}"
  end

  def self.ebs_application_url
    "https://#{aws_region}.console.aws.amazon.com/elasticbeanstalk/home?region=#{aws_region}#/application/overview?applicationName=#{ebs_application_name}"
  end

  def self.ebs_environment_url
    environment_details = begin
      ebs_client = OpsBot::AWS::EBS.new
      ebs_client.describe_environment
    rescue
      nil
    end

    environment_details.present? ?
      "https://#{aws_region}.console.aws.amazon.com/elasticbeanstalk/home?region=#{aws_region}#/environment/dashboard?applicationName=#{ebs_application_name}&environmentId=#{environment_details.environment_id}" :
      ebs_application_url
  end
end
