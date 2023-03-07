# frozen_string_literal: true

class OpsBot::Notification::Slack < OpsBot::Notification::Base
  CHANNEL_ALERT = 'alert'
  CHANNEL_NOTIFICATION = 'notification'

  def notify(channel:, template:, payload: {})
    client.auth_test

    client.chat_postMessage(
      channel: OpsBot::Context.env.slack.channels.send(channel),
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
