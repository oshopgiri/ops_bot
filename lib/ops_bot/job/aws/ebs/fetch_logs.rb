class OpsBot::Job::AWS::EBS::FetchLogs < OpsBot::Job::Base
  def self.perform
    ebs_client = OpsBot::Integration::AWS::EBS.new
    status = ebs_client.retrieve_logs

    status
  end

  def self.tags
    super

    aws_application_context = OpsBot::Context.env.aws.ebs.application

    OpsBot::Integration::Sentry.set_tags(
      {
        'aws.application': aws_application_context.name,
        'aws.environment': aws_application_context.environment.name
      }
    )
  end
end
