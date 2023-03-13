# frozen_string_literal: true

class OpsBot::Job::Base
  include OpsBot::Concern::Executable

  def self.tags
    Application.exception_notifier.set_tags(
      {
        'github.action.run_url': OpsBot::Context.utils.github.action.run.url
      }
    )
  end
end
