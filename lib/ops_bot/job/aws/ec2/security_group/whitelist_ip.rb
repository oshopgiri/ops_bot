class OpsBot::Job::AWS::EC2::SecurityGroup::WhitelistIP
  def self.perform
    security_group_client = OpsBot::Integration::AWS::EC2::SecurityGroup.new
    security_group_client.revoke_old_ips
    security_group_client.whitelist_ip

    0
  end
end
