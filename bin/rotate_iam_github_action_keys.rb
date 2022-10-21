require_relative '../config/boot.rb'

iam_client = DeployActions::AWS::IAM.new

new_access_key = begin
  iam_client.rotate_access_key
rescue
  nil
end

if new_access_key.present?
  DeployActions::Utils.parsed_serviced_repos.each do |repo|
    github_client = DeployActions::GitHub.new(repo: repo)
    {
      'AWS_ACCESS_KEY_ID': new_access_key.access_key_id,
      'AWS_SECRET_ACCESS_KEY': new_access_key.secret_access_key
    }.each do |name, value|
      github_client.set_action_secret(
        name: name.to_s,
        value: value
      )
    end
  end
end

slack_client = DeployActions::Notification::Slack.new
slack_client.notify(
  view_file: 'rotate_iam_github_action_keys.json.erb',
  payload: { new_access_key: new_access_key }
)

exit(0)
