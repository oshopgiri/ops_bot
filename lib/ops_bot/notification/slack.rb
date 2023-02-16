class OpsBot::Notification::Slack < OpsBot::Notification::Base
  def initialize
    @channel_ids = begin
      puts 'Initializing Slack client...'
      client.auth_test
      OpsBot::Context.env.slack.channel_ids
    rescue
      puts 'Unable to initialize Slack client. Skipping notification...'
      nil
    end
  end

  def notify(template:, payload: {})
    puts 'Sending notification...'
    return if @channel_ids.blank?
    puts @channel_ids

    client.chat_postMessage(
      channel: @channel_ids,
      blocks: render(
        view_file: template,
        instance: self,
        payload: payload
      )
    )

    puts 'Notification sent...'
  end

  private

    def client
      @client ||= ::Slack::Web::Client.new
    end
end
