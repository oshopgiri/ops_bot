class DeployActions::ENV::Build
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

  def self.source_directory
    ENV['SOURCE_DIRECTORY']
  end
end
