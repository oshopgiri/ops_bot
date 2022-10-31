require_relative '../config/boot.rb'

ebs_client = OpsBot::AWS::EBS.new
ebs_client.update_instance_type

exit(0)
