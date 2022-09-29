class DeployActions::AWS::EBS
  def initialize
    @application_name = DeployActions::ENV::AWS.ebs_application_name
    @environment_name = DeployActions::ENV::AWS.ebs_environment_name
    @instance_type = DeployActions::ENV::AWS.ebs_instance_type
    @log_file_path = DeployActions::ENV::Base.log_file_path
    @s3_bucket = DeployActions::ENV::AWS.s3_bucket_name
    @s3_key = DeployActions::ENV::AWS.s3_build_key
    @version_label = DeployActions::ENV::Build.build_version
  end

  def create_version
    client.create_application_version({
      application_name: @application_name,
      source_bundle: {
        s3_bucket: @s3_bucket,
        s3_key: @s3_key
      },
      version_label: @version_label
    })
  end

  def deploy_version
    client.update_environment({
      environment_name: @environment_name,
      version_label: @version_label
    })
  end

  def retrieve_logs
    request_logs

    response = client.retrieve_environment_info({
      environment_name: @environment_name,
      info_type: 'bundle'
    })

    if response.environment_info
      download_logs(url: response.environment_info.first.message)
      true
    else
      false
    end
  end

  def update_instance_type
    client.update_environment({
      environment_name: @environment_name,
      option_settings: [{
        namespace: 'aws:autoscaling:launchconfiguration',
        option_name: 'InstanceType',
        value: @instance_type
      }]
    })
  end

  def version_exists?
    response = client.describe_application_versions({
      application_name: @application_name,
      version_labels: [@version_label]
    })

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
      client.request_environment_info({
        environment_name: @environment_name,
        info_type: 'bundle'
      })

      sleep(30.seconds)
    end
end
