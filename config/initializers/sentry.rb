Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.environment = ENV['WORKFLOW_ENVIRONMENT'] || 'development'
end if ENV['SENTRY_DSN'].present?
