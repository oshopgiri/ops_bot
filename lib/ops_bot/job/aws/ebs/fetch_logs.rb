# frozen_string_literal: true

class OpsBot::Job::AWS::EBS::FetchLogs < OpsBot::Job::Base
  def self.perform
    ebs_client = OpsBot::Integration::AWS::EBS.new
    ebs_client.retrieve_logs
  end

  def self.tags
    super

    aws_application_context = OpsBot::Context.env.aws.ebs.application

    Application.exception_notifier.set_tags(
      {
        'aws.application': aws_application_context.name,
        'aws.environment': aws_application_context.environment.name
      }
    )
  end
end
