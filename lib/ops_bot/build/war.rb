# frozen_string_literal: true

class OpsBot::Build::WAR < OpsBot::Build::Base
  def package
    system("cd #{@source_directory} && mvn package -q -f pom.xml")
    build_file = Dir["#{@source_directory}/target/**.war"].first
    FileUtils.mv(build_file, @path) if exists?(path: build_file)
  end
end
