# frozen_string_literal: true

class OpsBot::Job::AWS::EBS::Deploy < OpsBot::Job::Base
  def self.perform
    build_client = OpsBot::Build.new
    ebs_client = OpsBot::Integration::AWS::EBS.new

    ebs_version_label = OpsBot::Context.utils.build.version

    unless build_client.uploaded?
      Application.logger.error("Build not found on S3: #{build_client.s3_uri}")
      return false
    end

    if ebs_client.version_exists?
      Application.logger.info(
        "Existing application version found on EBS: #{ebs_version_label}, skipping version creation..."
      )
    else
      ebs_client.create_version

      if ebs_client.version_exists?
        Application.logger.info("Created new EBS application version: #{ebs_version_label}")
      else
        Application.logger.error('Version creation failed. Check logs for errors.')
        return false
      end
    end

    ebs_client.deploy_version

    slack_client = OpsBot::Notification::Slack.new
    slack_client.notify(
      channel: OpsBot::Notification::Slack::CHANNEL_NOTIFICATION,
      template: 'aws-ebs-deploy.json.erb'
    )

    true
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
