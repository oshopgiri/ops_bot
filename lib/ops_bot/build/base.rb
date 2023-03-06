# frozen_string_literal: true

class OpsBot::Build::Base
  def initialize
    @type = OpsBot::Context.env.build.type
    @source_directory = OpsBot::Context.env.source.directory

    @name = OpsBot::Context.utils.build.name
    @build_path = OpsBot::Context.utils.build.path
  end

  def build_exists?
    File.file?(@build_path)
  end

  def package
    raise 'method definition missing!'
  end
end
