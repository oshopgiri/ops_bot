class OpsBot::Job::AWS::EBS::UpdateInstanceType
  def self.perform
    ebs_client = OpsBot::Integration::AWS::EBS.new
    ebs_client.update_instance_type

    0
  end
end
