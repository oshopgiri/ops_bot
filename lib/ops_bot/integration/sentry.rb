class OpsBot::Integration::Sentry
  def self.capture_exception(exception)
    $logger.error(exception)

    return unless Sentry.initialized?
    Sentry.capture_exception(exception)
  end

  def self.set_tags(*args)
    return unless Sentry.initialized?
    Sentry.set_tags(*args)
  end
end
