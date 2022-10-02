class DeployActions::Slack
  def initialize
    client.auth_test
    @channel_ids = DeployActions::Utils.slack_channel_ids
  end

  def notify(payload:)
    return if @channel_ids.blank?

    client.postMessage(
      channel: @channel_ids,
      blocks: payload
    )
  end

  private

    def client
      @client ||= Slack::Web::Client.new
    end
end
