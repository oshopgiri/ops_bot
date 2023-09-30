# frozen_string_literal: true

class OpsBot::Job::AWS::CloudFront::CreateInvalidation < OpsBot::Job::Base
  def self.perform
    cloud_front_client = OpsBot::Integration::AWS::CloudFront.new(
      distribution_id: OpsBot::Context.env.aws.cloud_front.distribution_id
    )

    cloud_front_client.create_invalidation(
      paths: OpsBot::Context.env.aws.cloud_front.invalidation_paths.split(',')
    )

    true
  end
end
