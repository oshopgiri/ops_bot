class OpsBot::Build::Base
  def initialize
    @type = OpsBot::Context.env.build.type
    @name = DeployActions::Utils.build_name
    @build_path = DeployActions::Utils.build_path
    @source_directory = OpsBot::Context.env.source.directory
  end

  def build_exists?
    File.file?(@build_path)
  end

  def package
    raise 'method definition missing!'
  end
end

# def build
#   case @type
#   when 'war'
#     package_war
#   when 'zip'
#     package_zip
#   end
# end
