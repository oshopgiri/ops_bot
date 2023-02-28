class OpsBot::Integration::Sentry
  def self.initialize
    return unless Sentry.initialized?

    Sentry.set_tags('aws.ebs.application': OpsBot::Context.env.aws.ebs.application.name)
    Sentry.set_tags('aws.ebs.environment': OpsBot::Context.env.aws.ebs.application.environment.name)
    Sentry.set_tags('github.branch': OpsBot::Context.env.github.branch.ref)
    Sentry.set_tags('github.branch.commit_sha': OpsBot::Context.env.github.branch.sha)
    Sentry.set_tags('github.repository': OpsBot::Context.env.github.repository.name)
    Sentry.set_tags('github.action.run_url': OpsBot::Context.utils.github.action.run.url)
  end

  def self.capture_exception(exception)
    $logger.error(exception)

    return unless Sentry.initialized?
    Sentry.capture_exception(exception)
  end
end
