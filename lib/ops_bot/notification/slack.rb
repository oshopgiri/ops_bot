module OpsBot::Notification
  class Slack < Base
    def initialize
      client.auth_test
      @channel_ids = OpsBot::Context.env.slack.channel_ids
    end

    def notify(view_file:, payload: {})
      return if @channel_ids.blank?

      client.chat_postMessage(
        channel: @channel_ids,
        blocks: render(
          view_file: view_file,
          instance: self,
          payload: payload
        )
      )
    end

    private

      def client
        @client ||= ::Slack::Web::Client.new
      end
  end
end
