require 'pathname'
boot_script = File.join(
  Pathname.new('/').relative_path_from(Pathname.new("/#{File.dirname(__FILE__)}")),
  'config/boot.rb'
)
require_relative boot_script

class AWSEBSUpdateInstanceType
  def self.perform
    ebs_client = OpsBot::Integration::AWS::EBS.new
    ebs_client.update_instance_type

    0
  end
end

exit(AWSEBSUpdateInstanceType.perform)
