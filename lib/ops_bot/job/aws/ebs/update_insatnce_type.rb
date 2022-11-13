class OpsBot::Job::AWS::EBS::UpdateInstanceType < OpsBot::Job::Base
  def self.perform
    ebs_client = OpsBot::Integration::AWS::EBS.new
    ebs_client.update_instance_type

    true
  end
end
