# frozen_string_literal: true

class OpsBot::Integration::Sentry
  include Singleton

  def capture_exception(exception)
    Application.logger.error(exception)
    Sentry.capture_exception(exception)
  end

  def set_tags(*args)
    Sentry.set_tags(*args)
  end
end
