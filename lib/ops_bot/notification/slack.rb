# frozen_string_literal: true

class OpsBot::Notification::Slack < OpsBot::Notification::Base
  CHANNEL_ALERT = 'alert'
  CHANNEL_NOTIFICATION = 'notification'

  def notify(channel:, template:, payload: {})
    client.auth_test

    channel_id = OpsBot::Context.env.slack.channels.send(channel)
    return unless channel_id

    client.chat_postMessage(
      channel: channel_id,
      blocks: self.class.render(
        view_file: template,
        instance: self,
        payload:
      )
    )
  rescue Slack::Web::Api::Errors::NotAuthed
    nil
  end

  private

  def client
    @client ||= ::Slack::Web::Client.new
  end
end
