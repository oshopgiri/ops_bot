module OpsBot::Concern::Executable
  extend ActiveSupport::Concern

  class_methods do
    def execute
      tags
      result = perform
      result ? 0 : 1
    rescue => exception
      OpsBot::Integration::Sentry.capture_exception(exception)
      1
    end

    def tags
      github_context = OpsBot::Context.env.github

      OpsBot::Integration::Sentry.set_tags(
        {
          'github.branch': github_context.branch.ref,
          'github.commit': github_context.branch.sha,
          'github.repository': github_context.repository.name,
          'github.action.run_url': OpsBot::Context.utils.github.action.run.url
        }
      )
    end
  end
end
