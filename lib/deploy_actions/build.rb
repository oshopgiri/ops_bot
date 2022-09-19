class DeployActions::Build
  def initialize
    @type = DeployActions::Utils.build_type
    @name = DeployActions::Utils.build_name
    @build_path = DeployActions::Utils.build_path
    @source_directory = DeployActions::Utils.source_directory
  end

  def build
    case @type
    when 'war'
      package_war
    when 'zip'
      package_zip
    end
  end

  def build_exists?
    File.file?(@build_path)
  end

  private

    def package_zip
      system("cd #{@source_directory} && zip #{@name} -qr * .[^.]*")
      FileUtils.mv(
        "#{@source_directory}/#{@name}",
        @build_path
      )
    end

    def package_war
      system("cd #{@source_directory} && mvn package -q -f pom.xml")
      FileUtils.mv(
        Dir["#{@source_directory}/target/**.war"].first,
        @build_path
      )
    end
end
