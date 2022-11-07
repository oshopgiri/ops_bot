require 'pathname'
boot_script = File.join(
  Pathname.new('/').relative_path_from(Pathname.new("/#{File.dirname(__FILE__)}")),
  'config/boot.rb'
)
require_relative boot_script

class AWSEC2SecurityGroupWhitelistIP
  def self.perform
    security_group_client = OpsBot::Integration::AWS::EC2::SecurityGroup.new
    security_group_client.revoke_old_ips
    security_group_client.whitelist_ip

    0
  end
end

exit(AWSEC2SecurityGroupWhitelistIP.perform)
