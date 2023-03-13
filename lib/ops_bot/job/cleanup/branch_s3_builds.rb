# frozen_string_literal: true

class OpsBot::Job::Cleanup::BranchS3Builds < OpsBot::Job::Base
  def self.perform
    build_client = OpsBot::Build::Base.new
    build_client.delete_s3_branch_directory

    true
  end

  def self.tags
    super

    Application.exception_notifier.set_tags(
      {
        'github.branch': OpsBot::Context.env.github.event.branch.ref
      }
    )
  end
end
