module OpsBot::Concern::Executable
  extend ActiveSupport::Concern

  class_methods do
    def execute
      result = perform
      result ? 0 : 1
    rescue => exception
      $logger.error(exception)
      Sentry.capture_exception(exception) if Sentry.initialized?
      1
    end
  end
end
