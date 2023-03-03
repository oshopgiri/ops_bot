Sentry.init do |config|
  config.environment = ENV['WORKFLOW_ENVIRONMENT'] || 'development'
end
