class DeployActions::Notification::Slack < DeployActions::Notification::Base
  def initialize
    client.auth_test
    @channel_ids = DeployActions::Utils.slack_channel_ids
  end

  def notify(view_file:, payload: {})
    return if @channel_ids.blank?

    client.chat_postMessage(
      channel: @channel_ids,
      blocks: parse(view_file: view_file, payload: payload)
    )
  end

  private

    def client
      @client ||= ::Slack::Web::Client.new
    end
end
