# frozen_string_literal: true

class OpsBot::Integration::AWS::EBS
  MAX_RETRIES = 5.freeze

  def initialize(application_name: '', environment_name: '')
    @application_name = application_name
    @environment_name = environment_name
  end

  def create_version(build:, label:)
    return unless build[:s3].present?

    client
      .create_application_version(
        {
          application_name: @application_name,
          source_bundle: {
            s3_bucket: build[:s3][:bucket],
            s3_key: build[:s3][:key]
          },
          version_label: label
        }
      )
  end

  def deploy_version(label:)
    return unless label.present?

    try = 0
    begin
      client
        .update_environment(
          {
            environment_name: @environment_name,
            version_label: label
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

  def retrieve_logs(file_path:)
    request_logs

    response = client
                 .retrieve_environment_info(
                   {
                     environment_name: @environment_name,
                     info_type: 'bundle'
                   }
                 )

    if response.environment_info
      download_logs(
        file_path:,
        url: response.environment_info.first.message
      )
      true
    else
      false
    end
  end

  def update_instance_type(type:)
    client
      .update_environment(
        {
          environment_name: @environment_name,
          option_settings: [
            {
              namespace: 'aws:autoscaling:launchconfiguration',
              option_name: 'InstanceType',
              value: type
            }
          ]
        }
      )
  end

  def version_exists?(label:)
    response = client
                 .describe_application_versions(
                   {
                     application_name: @application_name,
                     version_labels: [label]
                   }
                 )

    !response.application_versions.empty?
  end

  private

  def client
    @client ||= Aws::ElasticBeanstalk::Client.new
  end

  def download_logs(file_path:, url:)
    system("curl '#{url}' --output #{file_path}")
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
