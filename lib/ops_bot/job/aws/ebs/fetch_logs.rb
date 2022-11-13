class OpsBot::Job::AWS::EBS::FetchLogs < OpsBot::Job::Base
  def self.perform
    ebs_client = OpsBot::Integration::AWS::EBS.new
    status = ebs_client.retrieve_logs

    status
  end
end
