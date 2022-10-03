require_relative './config/boot.rb'

iam_client = DeployActions::AWS::IAM.new
serviced_repos = DeployActions::Utils.parsed_serviced_repos
slack_client = DeployActions::Slack.new

new_access_key = begin
	iam_client.rotate_access_key
rescue
	nil
end

if new_access_key.present?
	serviced_repos.each do |repo|
		github_client = DeployActions::GitHub.new(repo: repo)
		github_client.set_action_secret(
			name: 'AWS_ACCESS_KEY_ID',
			value: new_access_key.access_key_id
		)
		github_client.set_action_secret(
			name: 'AWS_SECRET_ACCESS_KEY',
			value: new_access_key.secret_access_key
		)
	end
end

slack_client.notify(payload: [
	{
		'type': 'section',
		'text': {
			'type': 'mrkdwn',
			'text': 'Key rotation: *AWS IAM ~<>~ GitHub Actions*'
		}
	},
	{
		'type': 'section',
		'fields': [
			{
				'type': 'mrkdwn',
				'text': "*Logs:* <#{DeployActions::Utils.action_run_url}|#{DeployActions::Utils.action_run_name}>"
			},
			{
				'type': 'mrkdwn',
				'text': "*Status:* #{new_access_key.present? ? ':large_green_circle:' : ':red_circle:'}"
			}
		]
	}
])

exit(0)
