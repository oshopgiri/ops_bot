# frozen_string_literal: true

class OpsBot::Integration::AWS::CloudFront
  def initialize(distribution_id: '')
    @distribution_id = distribution_id
  end

  def create_invalidation(paths: [])
    response = client.create_invalidation(
      distribution_id: @distribution_id,
      invalidation_batch: {
        paths: { quantity: paths.count, items: paths },
        caller_reference: Time.now.to_i.to_s
      }
    )

    Application.logger.info('New invalidation created, waiting for completion...')

    await_invalidation_completion(invalidation_id: response.invalidation.id)
  end

  private

  def await_invalidation_completion(invalidation_id:)
    loop do
      response = client.get_invalidation(
        distribution_id: @distribution_id,
        id: invalidation_id
      )
      if response.invalidation.status == 'Completed'
        Application.logger.info('Invalidation complete!')
        break
      end

      sleep(10.seconds.to_i)
    end
  end

  def client
    @client ||= Aws::CloudFront::Client.new
  end
end
