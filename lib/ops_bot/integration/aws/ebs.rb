# frozen_string_literal: true

class OpsBot::Integration::AWS::EBS
  MAX_RETRIES = 5.freeze

  def initialize
    @application_name = OpsBot::Context.env.aws.ebs.application.name
    @environment_name = OpsBot::Context.env.aws.ebs.application.environment.name
    @instance_type = OpsBot::Context.env.aws.ebs.application.environment.config.instance_type
    @log_file_path = OpsBot::Context.env.log.file_path
    @s3_bucket = OpsBot::Context.env.aws.s3.buckets.build

    @build_s3_key = OpsBot::Context.utils.build.s3_key
    @version_label = OpsBot::Context.utils.build.version
  end

  def create_version
    client
      .create_application_version(
        {
          application_name: @application_name,
          source_bundle: {
            s3_bucket: @s3_bucket,
            s3_key: @build_s3_key
          },
          version_label: @version_label
        }
      )
  end

  def deploy_version
    try = 0

    begin
      client
        .update_environment(
          {
            environment_name: @environment_name,
            version_label: @version_label
          }
        )
    rescue Aws::ElasticBeanstalk::Errors::InvalidParameterValue => e
      raise unless e.message.include? 'is in an invalid state for this operation. Must be Ready.'

      try += 1
      Application.logger.info(
        "Version deployment failed as instance is not Ready. (retrying #{try} of #{MAX_RETRIES})"
      )
      if try < MAX_RETRIES
        sleep((try * 10).seconds)
        retry
      end
    end
  end

  def describe_environment
    response = client.describe_environments({ environment_names: [@environment_name] })
    response.environments&.first
  end

  def describe_environments
    response = client.describe_environments
    response.environments
  end

  def retrieve_logs
    request_logs

    response = client
                 .retrieve_environment_info(
                   {
                     environment_name: @environment_name,
                     info_type: 'bundle'
                   }
                 )

    if response.environment_info
      download_logs(url: response.environment_info.first.message)
      true
    else
      false
    end
  end

  def update_instance_type
    client
      .update_environment(
        {
          environment_name: @environment_name,
          option_settings: [
            {
              namespace: 'aws:autoscaling:launchconfiguration',
              option_name: 'InstanceType',
              value: @instance_type
            }
          ]
        }
      )
  end

  def version_exists?
    response = client
                 .describe_application_versions(
                   {
                     application_name: @application_name,
                     version_labels: [@version_label]
                   }
                 )

    !response.application_versions.empty?
  end

  private

  def client
    @client ||= Aws::ElasticBeanstalk::Client.new
  end

  def download_logs(url:)
    system("curl '#{url}' --output #{@log_file_path}")
  end

  def request_logs
    client
      .request_environment_info(
        {
          environment_name: @environment_name,
          info_type: 'bundle'
        }
      )

    sleep(30.seconds)
  end
end
