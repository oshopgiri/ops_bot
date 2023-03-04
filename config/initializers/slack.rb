# frozen_string_literal: true

Slack.configure do |config|
  config.token = ENV['SLACK_BOT_TOKEN']
end

Slack::Web::Client.configure do |config|
  config.ca_file = OpenSSL::X509::DEFAULT_CERT_FILE
  config.ca_path = OpenSSL::X509::DEFAULT_CERT_DIR
end
