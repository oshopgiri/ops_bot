class DeployActions::ENV::Base
  def self.normalized_branch_name
    ENV['GITHUB_REF_NAME'].titleize.parameterize
  end

  def self.normalized_application_name
    DeployActions::ENV::AWS.ebs_application_name&.parameterize
  end

  def self.parsed_serviced_repos
    ENV['SERVICED_REPOS'].split(';').map(&:strip)
  end

  def self.log_file_path
    ENV['LOG_FILE_PATH']
  end
end
