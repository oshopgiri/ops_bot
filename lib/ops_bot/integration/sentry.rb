class OpsBot::Integration::Sentry
  def self.capture_exception(exception)
    $logger.error(exception)
    Sentry.capture_exception(exception)
  end

  def self.set_tags(*args)
    Sentry.set_tags(*args)
  end
end
