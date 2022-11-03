require_relative '../config/boot.rb'

ebs_client = OpsBot::AWS::EBS.new
ebs_client.retrieve_logs

exit(0)
