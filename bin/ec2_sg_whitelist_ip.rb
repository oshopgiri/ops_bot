require_relative '../config/boot.rb'

security_group_client = OpsBot::AWS::EC2::SecurityGroup.new
security_group_client.revoke_old_ips
security_group_client.whitelist_ip

exit(0)
