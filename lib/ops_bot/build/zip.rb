class OpsBot::Build::ZIP < OpsBot::Build::Base
  def package
    system("cd #{@source_directory} && zip #{@name} -qr * .[^.]*")
    FileUtils.mv(
      "#{@source_directory}/#{@name}",
      @build_path
    )
  end
end
