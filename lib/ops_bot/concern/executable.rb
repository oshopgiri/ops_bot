# frozen_string_literal: true

module OpsBot::Concern::Executable
  extend ActiveSupport::Concern

  class_methods do
    def execute
      tags
      result = perform
      result ? 0 : 1
    rescue => e
      Application.capture_exception(e)
      1
    end

    def tags
      github_context = OpsBot::Context.env.github

      Application.exception_notifier.set_tags(
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
