class OpsBot::Job::KeyRotation::IAMGitHubAction < OpsBot::Job::Base
  def self.perform
    iam_client = OpsBot::Integration::AWS::IAM.new

    begin
      new_access_key = iam_client.rotate_access_key

      OpsBot::Context.env.access_key.serviced_repos.each do |repo|
        github_client = OpsBot::Integration::GitHub.new(repository: repo)

        {
          'AWS_ACCESS_KEY_ID': new_access_key.access_key_id,
          'AWS_SECRET_ACCESS_KEY': new_access_key.secret_access_key
        }.each do |name, value|
          github_client.set_action_secret(
            name: name,
            value: value
          )
        end
      end
    rescue
      new_access_key = nil
    ensure
      slack_client = OpsBot::Notification::Slack.new
      slack_client.notify(
        template: 'key_rotation-iam_github_action.json.erb',
        payload: {
          new_access_key: new_access_key
        }
      )
    end

    new_access_key.present?
  end
end
