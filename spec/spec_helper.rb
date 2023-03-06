# frozen_string_literal: true

ENV['APP_ENV'] = 'test'

require_relative '../config/boot'

Dotenv.load('./spec/fixtures/.env', './spec/fixtures/.secrets')
OpsBot::Context.build

RSpec.configure do |config|
  config.before(:all) do
    Application.logger.level = Logger::FATAL
  end

  config.after(:all) do
    Application.logger.level = Logger::DEBUG
  end
end
