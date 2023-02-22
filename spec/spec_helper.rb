ENV['APP_ENV'] = 'test'

require_relative '../config/boot.rb'

RSpec.configure do |config|
  config.before(:all) do
    $logger.level = Logger::ERROR
  end
  
  config.after(:all) do
    $logger.level = Logger::DEBUG
  end
end
