# frozen_string_literal: true

class OpsBot::Job::AWS::EBS::FetchLogs < OpsBot::Job::Base
  def self.perform
    ebs_client = OpsBot::Integration::AWS::EBS.new(
      application_name: OpsBot::Context.env.aws.ebs.application.name,
      environment_name: OpsBot::Context.env.aws.ebs.application.environment.name
    )
    ebs_client.retrieve_logs(file_path: OpsBot::Context.env.log.file_path)
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
