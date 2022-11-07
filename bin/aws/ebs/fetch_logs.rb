require 'pathname'
boot_script = File.join(
  Pathname.new('/').relative_path_from(Pathname.new("/#{File.dirname(__FILE__)}")),
  'config/boot.rb'
)
require_relative boot_script

class AWSEBSFetchLogs
  def self.perform
    ebs_client = OpsBot::AWS::EBS.new
    status = ebs_client.retrieve_logs

    status ? 0 : 1
  end
end

exit(AWSEBSFetchLogs.perform)
