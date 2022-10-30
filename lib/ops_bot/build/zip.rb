module OpsBot::Build
  class ZIP < Base
    def package
      system("cd #{@source_directory} && zip #{@name} -qr * .[^.]*")
      FileUtils.mv(
        "#{@source_directory}/#{@name}",
        @build_path
      )
    end
  end
end
