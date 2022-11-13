class OpsBot::Job::AWS::EC2::SecurityGroup::WhitelistIP < OpsBot::Job::Base
  def self.perform
    security_group_client = OpsBot::Integration::AWS::EC2::SecurityGroup.new
    security_group_client.revoke_old_ips
    security_group_client.whitelist_ip

    true
  end
end
