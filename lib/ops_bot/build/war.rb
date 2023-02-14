class OpsBot::Build::WAR < OpsBot::Build::Base
  def package
    system("cd #{@source_directory} && mvn package -q -f pom.xml")
    FileUtils.mv(
      Dir["#{@source_directory}/target/**.war"].first,
      @build_path
    )
  end
end