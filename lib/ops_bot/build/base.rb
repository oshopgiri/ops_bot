class OpsBot::Build::Base
  def initialize
    @type = OpsBot::Context.env.build.type
    @name = OpsBot::Context.utils.build.name
    @build_path = OpsBot::Context.utils.build.path
    @source_directory = OpsBot::Context.env.source.directory
  end

  def build_exists?
    File.file?(@build_path)
  end

  def package
    raise 'method definition missing!'
  end
end
