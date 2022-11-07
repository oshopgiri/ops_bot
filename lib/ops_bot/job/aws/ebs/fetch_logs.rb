class OpsBot::Job::AWS::EBS::FetchLogs
  def self.perform
    ebs_client = OpsBot::Integration::AWS::EBS.new
    status = ebs_client.retrieve_logs

    status ? 0 : 1
  end
end
