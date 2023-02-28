class OpsBot::Integration::Sentry
  def self.initialize
    return unless Sentry.initialized?

    # AWS tags
    aws_application_context = OpsBot::Context.env.aws.ebs.application
    Sentry.set_tags('aws.application': aws_application_context.name) if aws_application_context.name.present?
    Sentry.set_tags('aws.environment': aws_application_context.environment.name) if aws_application_context.environment.name.present?

    # GitHub tags
    github_context = OpsBot::Context.env.github
    Sentry.set_tags('github.branch': github_context.branch.ref)
    Sentry.set_tags('github.commit': github_context.branch.sha)
    Sentry.set_tags('github.repository': github_context.repository.name)
    Sentry.set_tags('github.action.run_url': OpsBot::Context.utils.github.action.run.url)
  end

  def self.capture_exception(exception)
    $logger.error(exception)

    return unless Sentry.initialized?
    Sentry.capture_exception(exception)
  end
end
