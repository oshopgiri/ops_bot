class DeployActions::Notification::Slack < DeployActions::Notification::Base
  def initialize
    @channel_ids = begin
      client.auth_test
      DeployActions::Utils.slack_channel_ids
    rescue
      puts '[ERROR] Failed to initialize Slack client'
      nil
    end
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
