# frozen_string_literal: true

class OpsBot::Job::Cleanup::BranchS3Builds < OpsBot::Job::Base
  def self.perform
    build_client = OpsBot::Build::Base.new
    build_client.s3_cleanup

    true
  end
end
