module OpsBot::Concern::Executable
  extend ActiveSupport::Concern

  class_methods do
    def execute
      result = perform
      result ? 0 : 1
    rescue => exception
      OpsBot::Integration::Sentry.capture_exception(exception)
      1
    end
  end
end
